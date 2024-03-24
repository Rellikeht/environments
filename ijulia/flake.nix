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
        common = import ../jupyter.nix {inherit pkgs;};
        utils = import ../utils.nix {inherit pkgs;};

        julia = pkgs.julia-bin;
        packages =
          common.shell-packages
          ++ [julia]
          ++ (common.python-packages pkgs.python311Packages)
          ++ (with self.packages.${system}; [run]);
      in {
        devShells = {
          default = utils.defaultShell packages;
        };

        packages =
          rec {
            run = pkgs.writeScriptBin "ijulia" ''
              ${julia}/bin/julia -e '
              using Pkg
              Pkg.activate(".")
              if !haskey(Pkg.project().dependencies, "IJulia")
                Pkg.add("IJulia")
              end
              using IJulia
              IJulia.jupyterlab(dir=pwd())
              '
            '';
            default = run;
          }
          // common.out-packages;

        apps = rec {
          run = {
            type = "app";
            program = "${self.packages.${system}.run}/bin/ijulia";
          };
          default = run;
        };
      }
    );
}
