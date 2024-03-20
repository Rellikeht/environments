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
        buildInputs = with pkgs; [
          julia-bin
        ];
        def = with pkgs;
          mkShell {
            inherit buildInputs;
            phases = [];
            packages = [self.packages.${system}.default];
            shellHook = '''';
          };
      in {
        devShells = {
          default = def;
        };

        packages.default = pkgs.writeScriptBin "pluto" ''
          ${julia}/bin/julia -e '
          using Pkg
          Pkg.activate(".")
          if !haskey(Pkg.project().dependencies, "Pluto")
            Pkg.add("Pluto")
          end

          using Pluto
          Pluto.run(
              auto_reload_from_file=true,
              launch_browser=false
          )
          '
        '';

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/pluto";
        };
      }
    );
}
