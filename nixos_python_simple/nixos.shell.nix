{pkgs ? import <nixpkgs> {}}: let
  buildInputs = with pkgs; [
    zlib
    pkgs.stdenv.cc.cc.lib
  ];
  ld_path = "${pkgs.lib.makeLibraryPath buildInputs}";
in
  pkgs.mkShell {
    inherit buildInputs;
    phases = [];
    shellHook = ''
      LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
    '';
  }
