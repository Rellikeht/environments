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
            julia
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
          };
      in {
        devShells = {
          default = def;
          shellHook = ''
            # What is going on here
          '';
        };

        packages.default = pkgs.writeScriptBin "ijulia" ''
          ${julia}/bin/julia -e "
          using Pkg
          Pkg.activate(\".\")
          if !haskey(Pkg.project().dependencies, "IJulia")
            Pkg.add("IJulia")
          end
          using IJulia
          IJulia.jupyterlab(dir=pwd())
          "
        '';

        # An app that uses the `runme` package
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/ijulia";
        };
      }
    );
}
