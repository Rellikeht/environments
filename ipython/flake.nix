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
        common-jup = import ../jupyter.nix {inherit pkgs;};
        utils = import ../utils.nix {inherit pkgs;};
        common-py = import ../python.nix {inherit pkgs;};

        python = pkgs.python311.withPackages (ps:
          (common-jup.python-packages ps)
          ++ (common-py.python-packages ps)
          ++ (with ps; [
            ipykernel
            ipython

            matplotlib
            numpy
            pandas
            sympy
          ]));

        packages =
          common-jup.shell-packages
          ++ common-py.shell-packages
          ++ [python]
          ++ (with self.packages.${system}; [run])
          ++ (with pkgs; []);
      in
        {
          devShells = {
            default = utils.defaultShell packages;
          };

          packages =
            rec {
              run = pkgs.writeScriptBin "ipyrun" ''exec jupyter-lab'';
              default = run;
            }
            // common-jup.out-packages;

          apps = rec {
            run = {
              type = "app";
              program = "${self.packages.${system}.run}/bin/ipyrun";
            };
            default = run;
          };
        }
        // {inherit utils;}
    );
}
