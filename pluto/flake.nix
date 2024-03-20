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
          ++ (with pkgs; [
            ])
          ++ (
            with self.packages.${system}; [
              run
            ]
          );

        default = with pkgs;
          mkShell {
            inherit packages;
            phases = [];
            shellHook = '''';
          };
      in {
        devShells = {inherit default;};

        packages = rec {
          run = pkgs.writeScriptBin "pluto" ''
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
          default = run;
        };

        apps = rec {
          run = {
            type = "app";
            program = "${self.packages.${system}.run}/bin/pluto";
          };
          default = run;
        };
      }
    );
}
