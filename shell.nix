let 
  nixpkgs = import (
    let
      version = "eca0d38e22981ba54f3185b1ff16a5e67d483776";
    in builtins.fetchTarball {
      name   = "nixpkgs-${version}";
      url    = "https://github.com/NixOS/nixpkgs/archive/${version}.tar.gz";
      sha256 = "162ip8l5x5v1wwkdq7xrhqc9155c5i294l7rl18r8skmrncjad12";
      }
    ) {};

in nixpkgs.mkShell {
  buildInputs = [
    nixpkgs.bashInteractive
    nixpkgs.gitAndTools.lefthook
    nixpkgs.jq
  ];
}
