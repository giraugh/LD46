{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "LD46env";
  buildInputs = [ 
    (pkgs.callPackage ./nix/bpm-tools.nix {} )
    (pkgs.callPackage ./nix/godot.nix {} )
  ];
}
