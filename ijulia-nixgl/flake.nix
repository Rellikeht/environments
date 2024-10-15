{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
    # nix-gl.url = "github:nix-community/nixGL";
    nix-gl.url = "github:nix-community/nixGL/a9d19d98163a9de10583c63e2d5b0ef088a93a7e";
    # temporary :(
  };

  outputs = {
    self,
    nixpkgs,
    flakeUtils,
    nix-gl,
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [nix-gl.overlay];
        };
        common = import ../jupyter/utils.nix {inherit pkgs;};
        utils = import ../utils.nix {inherit pkgs;};

        julia = pkgs.julia-bin;
        packages =
          common.shell-packages
          ++ (with pkgs.nixgl; [
            auto.nixGLDefault
            auto.nixGLNvidia
            nixGLIntel
          ])
          ++ []
          ++ (common.python-packages pkgs.python311Packages)
          ++ (with self.packages.${system}; [
            ijulia-run
            julia-run
          ]);
      in {
        devShells = {
          default = utils.defaultShell packages;
        };

        packages = let
          nixgl-run = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL";
        in
          rec
          {
            # ${julia-run}/bin/julia -e '
            julia-run = pkgs.writeScriptBin "julia" ''
              ${julia}/bin/julia $@
            '';
            ijulia-run = pkgs.writeScriptBin "ijulia" ''
              ${nixgl-run} ${julia}/bin/julia $@
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
