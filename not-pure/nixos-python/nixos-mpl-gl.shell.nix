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

    libGL
  ];
  ld_path = "${pkgs.lib.makeLibraryPath libs}";
  gl_drv_path = "/run/opengl-driver/lib";
in
  pkgs.mkShell {
    inherit buildInputs;
    phases = [];
    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${gl_drv_path}:${ld_path}"
    '';
  }
