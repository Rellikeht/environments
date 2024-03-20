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
        buildInputs = with pkgs; ([
            julia-bin
          ]
          ++ (with python311Packages; [
            notebook
            jupyter-console
            jupyter-core
            jupyterlab
          ]));
        def = with pkgs;
          mkShell {
            inherit buildInputs;

            phases = [
              "run"
            ];

            run = "${self.packages.${system}.default}/bin/ijulia";
            shellHook = ''
              # What is going on here
              alias irun="${self.packages.${system}.default}/bin/ijulia"
            '';
          };
      in {
        devShells = {
          default = def;
        };

        packages.default = pkgs.writeScriptBin "ijulia" ''
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

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/ijulia";
        };
      }
    );
}
