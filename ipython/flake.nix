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

        python = pkgs.python311.withPackages (ps:
          with ps; [
            notebook
            jupyter-console
            jupyter-core
            jupyterlab
            jupyterlab-lsp
            nbconvert
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
          ]);

        packages =
          [python]
          ++ (with self.packages.${system}; [
            run
            serv
            list
            stop
          ])
          ++ (with pkgs; [
            ruff
            # pylyzer
          ]);

        default = with pkgs;
          mkShell {
            inherit packages;
            phases = [];
            shellHook = '''';
          };
      in {
        devShells = {inherit default;};

        packages = rec {
          run = pkgs.writeScriptBin "ipyrun" '''';

          default = run;
          serv = pkgs.writeScriptBin "serv" ''jupyter server $@'';
          list = pkgs.writeScriptBin "list" ''jupyter server list'';
          stop = pkgs.writeScriptBin "stop" ''jupyter server stop'';
        };

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
