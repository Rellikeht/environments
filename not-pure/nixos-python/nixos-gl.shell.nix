{pkgs ? import <nixpkgs> {}}: let
  buildInputs = with pkgs; [
    zlib
    stdenv.cc.cc.lib
    glib
    libGL
  ];

  ld_path = "${pkgs.lib.makeLibraryPath buildInputs}";
  gl_drv_path = "/run/opengl-driver/lib";
in
  pkgs.mkShell {
    inherit buildInputs;
    phases = [];
    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${gl_drv_path}:${ld_path}"
    '';
  }
