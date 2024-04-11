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
      in {
        devShells = rec {
          default = pkgs.mkShell {
            phases = [];
            buildInputs = with pkgs; [
              zlib
            ];
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
            shellHook = '''';
          };
        };
      }
    );
}
