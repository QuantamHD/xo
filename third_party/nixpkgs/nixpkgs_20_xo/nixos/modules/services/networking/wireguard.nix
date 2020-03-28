{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.wireguard;

  kernel = config.boot.kernelPackages;

  # interface options

  interfaceOpts = { ... }: {

    options = {

      ips = mkOption {
        example = [ "192.168.2.1/24" ];
        default = [];
        type = with types; listOf str;
        description = "The IP addresses of the interface.";
      };

      privateKey = mkOption {
        example = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
        type = with types; nullOr str;
        default = null;
        description = ''
          Base64 private key generated by <command>wg genkey</command>.

          Warning: Consider using privateKeyFile instead if you do not
          want to store the key in the world-readable Nix store.
        '';
      };

      generatePrivateKeyFile = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Automatically generate a private key with
          <command>wg genkey</command>, at the privateKeyFile location.
        '';
      };

      privateKeyFile = mkOption {
        example = "/private/wireguard_key";
        type = with types; nullOr str;
        default = null;
        description = ''
          Private key file as generated by <command>wg genkey</command>.
        '';
      };

      listenPort = mkOption {
        default = null;
        type = with types; nullOr int;
        example = 51820;
        description = ''
          16-bit port for listening. Optional; if not specified,
          automatically generated based on interface name.
        '';
      };

      preSetup = mkOption {
        example = literalExample ''
          ${pkgs.iproute}/bin/ip netns add foo
        '';
        default = "";
        type = with types; coercedTo (listOf str) (concatStringsSep "\n") lines;
        description = ''
          Commands called at the start of the interface setup.
        '';
      };

      postSetup = mkOption {
        example = literalExample ''
          printf "nameserver 10.200.100.1" | ${pkgs.openresolv}/bin/resolvconf -a wg0 -m 0
        '';
        default = "";
        type = with types; coercedTo (listOf str) (concatStringsSep "\n") lines;
        description = "Commands called at the end of the interface setup.";
      };

      postShutdown = mkOption {
        example = literalExample "${pkgs.openresolv}/bin/resolvconf -d wg0";
        default = "";
        type = with types; coercedTo (listOf str) (concatStringsSep "\n") lines;
        description = "Commands called after shutting down the interface.";
      };

      table = mkOption {
        default = "main";
        type = types.str;
        description = ''The kernel routing table to add this interface's
        associated routes to. Setting this is useful for e.g. policy routing
        ("ip rule") or virtual routing and forwarding ("ip vrf"). Both numeric
        table IDs and table names (/etc/rt_tables) can be used. Defaults to
        "main".'';
      };

      peers = mkOption {
        default = [];
        description = "Peers linked to the interface.";
        type = with types; listOf (submodule peerOpts);
      };

      allowedIPsAsRoutes = mkOption {
        example = false;
        default = true;
        type = types.bool;
        description = ''
          Determines whether to add allowed IPs as routes or not.
        '';
      };

      socketNamespace = mkOption {
        default = null;
        type = with types; nullOr str;
        example = "container";
        description = ''The pre-existing network namespace in which the
        WireGuard interface is created, and which retains the socket even if the
        interface is moved via <option>interfaceNamespace</option>. When
        <literal>null</literal>, the interface is created in the init namespace.
        See <link
        xlink:href="https://www.wireguard.com/netns/">documentation</link>.
        '';
      };

      interfaceNamespace = mkOption {
        default = null;
        type = with types; nullOr str;
        example = "init";
        description = ''The pre-existing network namespace the WireGuard
        interface is moved to. The special value <literal>init</literal> means
        the init namespace. When <literal>null</literal>, the interface is not
        moved.
        See <link
        xlink:href="https://www.wireguard.com/netns/">documentation</link>.
        '';
      };
    };

  };

  # peer options

  peerOpts = {

    options = {

      publicKey = mkOption {
        example = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
        type = types.str;
        description = "The base64 public key the peer.";
      };

      presharedKey = mkOption {
        default = null;
        example = "rVXs/Ni9tu3oDBLS4hOyAUAa1qTWVA3loR8eL20os3I=";
        type = with types; nullOr str;
        description = ''
          Base64 preshared key generated by <command>wg genpsk</command>.
          Optional, and may be omitted. This option adds an additional layer of
          symmetric-key cryptography to be mixed into the already existing
          public-key cryptography, for post-quantum resistance.

          Warning: Consider using presharedKeyFile instead if you do not
          want to store the key in the world-readable Nix store.
        '';
      };

      presharedKeyFile = mkOption {
        default = null;
        example = "/private/wireguard_psk";
        type = with types; nullOr str;
        description = ''
          File pointing to preshared key as generated by <command>wg pensk</command>.
          Optional, and may be omitted. This option adds an additional layer of
          symmetric-key cryptography to be mixed into the already existing
          public-key cryptography, for post-quantum resistance.
        '';
      };

      allowedIPs = mkOption {
        example = [ "10.192.122.3/32" "10.192.124.1/24" ];
        type = with types; listOf str;
        description = ''List of IP (v4 or v6) addresses with CIDR masks from
        which this peer is allowed to send incoming traffic and to which
        outgoing traffic for this peer is directed. The catch-all 0.0.0.0/0 may
        be specified for matching all IPv4 addresses, and ::/0 may be specified
        for matching all IPv6 addresses.'';
      };

      endpoint = mkOption {
        default = null;
        example = "demo.wireguard.io:12913";
        type = with types; nullOr str;
        description = ''Endpoint IP or hostname of the peer, followed by a colon,
        and then a port number of the peer.'';
      };

      persistentKeepalive = mkOption {
        default = null;
        type = with types; nullOr int;
        example = 25;
        description = ''This is optional and is by default off, because most
        users will not need it. It represents, in seconds, between 1 and 65535
        inclusive, how often to send an authenticated empty packet to the peer,
        for the purpose of keeping a stateful firewall or NAT mapping valid
        persistently. For example, if the interface very rarely sends traffic,
        but it might at anytime receive traffic from a peer, and it is behind
        NAT, the interface might benefit from having a persistent keepalive
        interval of 25 seconds; however, most users will not need this.'';
      };

    };

  };


  generatePathUnit = name: values:
    assert (values.privateKey == null);
    assert (values.privateKeyFile != null);
    nameValuePair "wireguard-${name}"
      {
        description = "WireGuard Tunnel - ${name} - Private Key";
        requiredBy = [ "wireguard-${name}.service" ];
        before = [ "wireguard-${name}.service" ];
        pathConfig.PathExists = values.privateKeyFile;
      };

  generateKeyServiceUnit = name: values:
    assert values.generatePrivateKeyFile;
    nameValuePair "wireguard-${name}-key"
      {
        description = "WireGuard Tunnel - ${name} - Key Generator";
        wantedBy = [ "wireguard-${name}.service" ];
        requiredBy = [ "wireguard-${name}.service" ];
        before = [ "wireguard-${name}.service" ];
        path = with pkgs; [ wireguard ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          mkdir --mode 0644 -p "${dirOf values.privateKeyFile}"
          if [ ! -f "${values.privateKeyFile}" ]; then
            touch "${values.privateKeyFile}"
            chmod 0600 "${values.privateKeyFile}"
            wg genkey > "${values.privateKeyFile}"
            chmod 0400 "${values.privateKeyFile}"
          fi
        '';
      };

  generatePeerUnit = { interfaceName, interfaceCfg, peer }:
    let
      keyToUnitName = replaceChars
        [ "/" "-"    " "     "+"     "="      ]
        [ "-" "\\x2d" "\\x20" "\\x2b" "\\x3d" ];
      unitName = keyToUnitName peer.publicKey;
      psk =
        if peer.presharedKey != null
          then pkgs.writeText "wg-psk" peer.presharedKey
          else peer.presharedKeyFile;
      src = interfaceCfg.socketNamespace;
      dst = interfaceCfg.interfaceNamespace;
      ip = nsWrap "ip" src dst;
      wg = nsWrap "wg" src dst;
    in nameValuePair "wireguard-${interfaceName}-peer-${unitName}"
      {
        description = "WireGuard Peer - ${interfaceName} - ${peer.publicKey}";
        requires = [ "wireguard-${interfaceName}.service" ];
        after = [ "wireguard-${interfaceName}.service" ];
        wantedBy = [ "multi-user.target" "wireguard-${interfaceName}.service" ];
        environment.DEVICE = interfaceName;
        environment.WG_ENDPOINT_RESOLUTION_RETRIES = "infinity";
        path = with pkgs; [ iproute wireguard-tools ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = let
          wg_setup = "${wg} set ${interfaceName} peer ${peer.publicKey}" +
            optionalString (psk != null) " preshared-key ${psk}" +
            optionalString (peer.endpoint != null) " endpoint ${peer.endpoint}" +
            optionalString (peer.persistentKeepalive != null) " persistent-keepalive ${toString peer.persistentKeepalive}" +
            optionalString (peer.allowedIPs != []) " allowed-ips ${concatStringsSep "," peer.allowedIPs}";
          route_setup =
            optionalString interfaceCfg.allowedIPsAsRoutes
              (concatMapStringsSep "\n"
                (allowedIP:
                  "${ip} route replace ${allowedIP} dev ${interfaceName} table ${interfaceCfg.table}"
                ) peer.allowedIPs);
        in ''
          ${wg_setup}
          ${route_setup}
        '';

        postStop = let
          route_destroy = optionalString interfaceCfg.allowedIPsAsRoutes
            (concatMapStringsSep "\n"
              (allowedIP:
                "${ip} route delete ${allowedIP} dev ${interfaceName} table ${interfaceCfg.table}"
              ) peer.allowedIPs);
        in ''
          ${wg} set ${interfaceName} peer ${peer.publicKey} remove
          ${route_destroy}
        '';
      };

  generateInterfaceUnit = name: values:
    # exactly one way to specify the private key must be set
    #assert (values.privateKey != null) != (values.privateKeyFile != null);
    let privKey = if values.privateKeyFile != null then values.privateKeyFile else pkgs.writeText "wg-key" values.privateKey;
        src = values.socketNamespace;
        dst = values.interfaceNamespace;
        ipPreMove  = nsWrap "ip" src null;
        ipPostMove = nsWrap "ip" src dst;
        wg = nsWrap "wg" src dst;
        ns = if dst == "init" then "1" else dst;

    in
    nameValuePair "wireguard-${name}"
      {
        description = "WireGuard Tunnel - ${name}";
        requires = [ "network-online.target" ];
        after = [ "network.target" "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.DEVICE = name;
        path = with pkgs; [ kmod iproute wireguard-tools ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          ${optionalString (!config.boot.isContainer) "modprobe wireguard || true"}

          ${values.preSetup}

          ${ipPreMove} link add dev ${name} type wireguard
          ${optionalString (values.interfaceNamespace != null && values.interfaceNamespace != values.socketNamespace) "${ipPreMove} link set ${name} netns ${ns}"}

          ${concatMapStringsSep "\n" (ip:
            "${ipPostMove} address add ${ip} dev ${name}"
          ) values.ips}

          ${wg} set ${name} private-key ${privKey} ${
            optionalString (values.listenPort != null) " listen-port ${toString values.listenPort}"}

          ${ipPostMove} link set up dev ${name}

          ${values.postSetup}
        '';

        postStop = ''
          ${ipPostMove} link del dev ${name}
          ${values.postShutdown}
        '';
      };

  nsWrap = cmd: src: dst:
    let
      nsList = filter (ns: ns != null) [ src dst ];
      ns = last nsList;
    in
      if (length nsList > 0 && ns != "init") then "ip netns exec ${ns} ${cmd}" else cmd;
in

{

  ###### interface

  options = {

    networking.wireguard = {

      enable = mkOption {
        description = "Whether to enable WireGuard.";
        type = types.bool;
        # 2019-05-25: Backwards compatibility.
        default = cfg.interfaces != {};
        example = true;
      };

      interfaces = mkOption {
        description = "WireGuard interfaces.";
        default = {};
        example = {
          wg0 = {
            ips = [ "192.168.20.4/24" ];
            privateKey = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
            peers = [
              { allowedIPs = [ "192.168.20.1/32" ];
                publicKey  = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
                endpoint   = "demo.wireguard.io:12913"; }
            ];
          };
        };
        type = with types; attrsOf (submodule interfaceOpts);
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable (let
    all_peers = flatten
      (mapAttrsToList (interfaceName: interfaceCfg:
        map (peer: { inherit interfaceName interfaceCfg peer;}) interfaceCfg.peers
      ) cfg.interfaces);
  in {

    assertions = (attrValues (
        mapAttrs (name: value: {
          assertion = (value.privateKey != null) != (value.privateKeyFile != null);
          message = "Either networking.wireguard.interfaces.${name}.privateKey or networking.wireguard.interfaces.${name}.privateKeyFile must be set.";
        }) cfg.interfaces))
      ++ (attrValues (
        mapAttrs (name: value: {
          assertion = value.generatePrivateKeyFile -> (value.privateKey == null);
          message = "networking.wireguard.interfaces.${name}.generatePrivateKey must not be set if networking.wireguard.interfaces.${name}.privateKey is set.";
        }) cfg.interfaces))
        ++ map ({ interfaceName, peer, ... }: {
          assertion = (peer.presharedKey == null) || (peer.presharedKeyFile == null);
          message = "networking.wireguard.interfaces.${interfaceName} peer «${peer.publicKey}» has both presharedKey and presharedKeyFile set, but only one can be used.";
        }) all_peers;

    boot.extraModulePackages = [ kernel.wireguard ];
    environment.systemPackages = [ pkgs.wireguard-tools ];

    systemd.services =
      (mapAttrs' generateInterfaceUnit cfg.interfaces)
      // (listToAttrs (map generatePeerUnit all_peers))
      // (mapAttrs' generateKeyServiceUnit
      (filterAttrs (name: value: value.generatePrivateKeyFile) cfg.interfaces));

    systemd.paths = mapAttrs' generatePathUnit
      (filterAttrs (name: value: value.privateKeyFile != null) cfg.interfaces);

  });

}
