{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  scripts ? import ./scripts.nix {inherit pkgs;},
  shellFunc ? utils.hookShell,
}: let
  #  {{{
  b = builtins;
  #  }}}

  default = scripts.juprun;
  out-packages =
    # {{{
    (b.removeAttrs scripts ["shell-hook"])
    // {
      inherit default;
    }; # }}}

  shell-packages =
    # {{{
    (with pkgs; [
      bashInteractive
    ])
    ++ (with out-packages; [
      # {{{
      serv
      list
      stop
      juprun
    ]); # }}}
  # }}}
in {
  devShells.default =
    shellFunc shell-packages
    (
      scripts.shell-hook
      + ''''
    );
  packages = out-packages;

  apps.default = {
    #  {{{
    type = "app";
    program = "${default}/bin/ipyrun";
  }; #  }}}
}
