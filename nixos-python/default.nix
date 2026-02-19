{pkgs ? import <nixpkgs> {}}: let
  packages = with pkgs; [
  ];

  libs = with pkgs; [
    zlib
    stdenv.cc.cc.lib
    glib
  ];

  mlibs = with pkgs; [
    # for matplotlib to fucking work
    fontconfig
    libX11
    libxkbcommon
    freetype
    dbus
  ];
  ld_path = "${pkgs.lib.makeLibraryPath libs}";
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
  '';
in {
  devShells = {
    default = pkgs.mkShell {
      inherit shellHook;
      buildInputs = libs;
    };

    matplotlib = pkgs.mkShell {
      inherit shellHook;
      buildInputs = libs ++ mlibs;
    };
  };
}
