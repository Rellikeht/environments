{pkgs ? import <nixpkgs> {}}: let
  buildInputs = with pkgs; [
    zlib
    stdenv.cc.cc.lib
    glib
  ];

  ld_path = "${pkgs.lib.makeLibraryPath buildInputs}";
in
  pkgs.mkShell {
    inherit buildInputs;
    phases = [];
    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
    '';
  }
