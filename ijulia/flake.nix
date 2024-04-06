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
        pkgs = import nixpkgs {
          inherit system;
        };
        common = import ../jupyter.nix {inherit pkgs;};
        utils = import ../utils.nix {inherit pkgs;};

        julia = pkgs.julia-bin;
        packages =
          common.shell-packages
          ++ [julia]
          ++ (common.python-packages pkgs.python311Packages)
          ++ (with self.packages.${system}; [
            ijulia-run
          ]);
      in {
        devShells = {
          default = utils.defaultShell packages;
        };

        packages =
          rec
          {
            ijulia-run = pkgs.writeScriptBin "ijulia" ''
              exec julia -e '
                using Pkg
                Pkg.activate(".")
                if !haskey(Pkg.project().dependencies, "IJulia")
                  Pkg.add("IJulia")
                end
                using IJulia
                IJulia.jupyterlab(dir=pwd())
              '
            '';
            default = ijulia-run;
          }
          // common.out-packages;

        apps = rec {
          run = {
            type = "app";
            program = "${self.packages.${system}.ijulia-run}/bin/ijulia";
          };
          default = run;
        };
      }
    );
}
