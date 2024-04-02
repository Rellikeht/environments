{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flakeUtils,
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        packages =
          []
          ++ (with pkgs; [
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
            # busybox ?
          ])
          ++ (
            with self.packages.${system}; [
              sh
              # run
            ]
          );
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit packages;
            phases = [];
            shellHook = ''
            '';
          };
        };

        packages = rec {
          # Magical workaround, no idea how good this will be
          sh = pkgs.symlinkJoin {
            name = "sh";
            paths = [pkgs.dash];
            postBuild = ''
              ln -s $out/bin/dash $out/bin/sh
            '';
          };

          # run = pkgs.writeScriptBin "run" ''
          # '';
          # default = run;
        };

        apps = rec {
          # run = {
          #   type = "app";
          #   program = "${self.packages.${system}.run}/bin/run";
          # };
          # default = run;
        };
      }
    );
}
