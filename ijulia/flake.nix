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
        julia = pkgs.julia-bin;

        packages =
          [julia]
          ++ (with pkgs; ([]
            ++ (with python311Packages; [
              notebook
              jupyter-console
              jupyter-core
              jupyterlab
              jupyterlab-lsp
              nbconvert
            ])))
          ++ (with self.packages.${system}; [
            # ez
            run
            serv
            list
            stop
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

          serv = pkgs.writeScriptBin "serv" ''jupyter server $@'';
          list = pkgs.writeScriptBin "list" ''jupyter server list'';
          stop = pkgs.writeScriptBin "stop" ''jupyter server stop'';
          default = run;
        };

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
