load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")

nix_file_content = """
{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.ghcWithPackages (p: with p; [
  clash-ghc
  ghc-typelits-extra
  ghc-typelits-knownnat
  ghc-typelits-natnormalise
])
"""

def clash():
  nixpkgs_package(
    name = "clash",
    nix_file_content = nix_file_content,
    repositories = {
        "nixpkgs": "@nixpkgs//:default.nix",
    },
  )
