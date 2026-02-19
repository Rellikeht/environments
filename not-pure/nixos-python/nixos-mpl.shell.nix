{pkgs ? import <nixpkgs> {}}: let
  buildInputs = with pkgs; [
  ];

  libs = with pkgs; [
    zlib
    stdenv.cc.cc.lib
    glib

    # for matplotlib
    fontconfig
    libX11
    libxkbcommon
    freetype
    dbus
  ];
  ld_path = "${pkgs.lib.makeLibraryPath libs}";
in
  pkgs.mkShell {
    inherit buildInputs;
    phases = [];
    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
    '';
  }
