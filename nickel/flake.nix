{
  inputs = {
    # {{{
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  }; # }}}

  outputs = {
    self, # {{{
    nixpkgs,
    flakeUtils,
    # }}}
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        # {{{
        pkgs = nixpkgs.legacyPackages.${system};
        # }}}

        buildInputs = with pkgs; [
          # {{{
          nickel
          nls
          bashInteractive
        ]; # }}}

        def = with pkgs;
          mkShell {
            # {{{
            inherit buildInputs;
            phases = [];
            shellHook = ''
            '';
          }; # }}}
      in {
        devShells = {
          # {{{
          default = def;
        }; # }}}

        apps.default = {
          # {{{
          type = "app";
          program = "";
        }; # }}}
      }
    );
}
