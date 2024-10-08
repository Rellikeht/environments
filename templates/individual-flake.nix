{
  description = "Environment from default.nix";

  inputs = {
    # {{{
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  }; # }}}

  outputs = {
    # {{{
    self,
    nixpkgs,
    flakeUtils,
    # }}}
  }: let
    # just in case
    # systems = [];
  in
    flakeUtils.lib.eachDefaultSystem (
      system:
        import ./default.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        }
    );
}
