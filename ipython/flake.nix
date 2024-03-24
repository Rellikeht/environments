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

        python = pkgs.python311.withPackages (ps:
          (common.python-packages ps)
          ++ (with ps; [
            ipykernel
            ipython
            bpython
            pip
            python-lsp-server
            mypy
            pylsp-mypy
            pynvim

            matplotlib
            numpy
            pandas
            sympy
          ]));

        packages =
          common.shell-packages
          ++ [python]
          ++ (with self.packages.${system}; [
            run
          ])
          ++ (with pkgs; [
            ruff
            # pylyzer
          ]);
      in {
        devShells = {
          default = common.defaultShell packages;
        };

        packages =
          rec {
            run = pkgs.writeScriptBin "ipyrun" ''echo "TODO :<"'';
            default = run;
          }
          // common.out-packages;

        apps = rec {
          run = {
            type = "app";
            program = "${self.packages.${system}.run}/bin/ipyrun";
          };
          default = run;
        };
      }
    );
}
