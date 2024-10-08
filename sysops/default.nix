{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  #  }}}
}: let
  # Magical workaround, no idea how good this will be
  sh = pkgs.symlinkJoin {
    # {{{
    name = "sh";
    paths = [pkgs.dash];
    postBuild = ''
      ln -s $out/bin/dash $out/bin/sh
    '';
  }; # }}}

  # run = pkgs.writeScriptBin "run" ''
  # '';

  shellPackages =
    []
    ++ (with pkgs; [
      # {{{
      gnumake
      gdb
      gcc
      binutils
      valgrind

      hyperfine
      pv

      coreutils
      gnused
      gawk
      bat

      gnutar
      gzip
      zip
      unzip

      bashInteractive
    ]) # }}}
    ++ [sh];
in {
  packages = {
    inherit sh;
  };

  devShells = {
    #  {{{
    default = pkgs.mkShell {
      # {{{
      packages = shellPackages;
      phases = [];
      shellHook = ''
      '';
    }; # }}}
  }; #  }}}

  # apps = rec {
  #   # {{{
  #   # run = {
  #   #   type = "app";
  #   #   program = "${self.packages.${system}.run}/bin/run";
  #   # };
  #   # default = run;
  # }; # }}}
}
