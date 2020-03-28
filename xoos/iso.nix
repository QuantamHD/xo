# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-kde.nix>
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  
  isoImage.storeContents = [
    { 
      source = (pkgs.fetchgit {url=https://github.com/QuantamHD/xo.git; sha256="0cf94lvd7nvlr7vjxzv73mr4qhn2lz3ayywsw5pmma7a0d0q5bm5";}).outPath;
      target = "/xo";
    }
  ];

}

