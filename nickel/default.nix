{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils/utils.nix {inherit pkgs;},
  #  }}}
}: let
  buildInputs = with pkgs; [
    # {{{
    nickel
    nls
    bashInteractive
  ]; # }}}
in {
  devShells.default =
    # {{{
    pkgs.mkShell {
      inherit buildInputs;
      phases = [];
      shellHook = ''
      '';
    }; # }}}

  # apps.default = {
  #   # {{{
  #   type = "app";
  #   program = "";
  # }; # }}}
}
