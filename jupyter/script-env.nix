{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils/utils.nix {inherit pkgs;},
  scripts ? import ./scripts.nix {inherit pkgs;},
  shellFunc ? utils.hookShell,
}: let
  #  {{{
  b = builtins;
  #  }}}

  default = scripts.lab;
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
      lab
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
    program = "${default}/bin/lab";
  }; #  }}}
}
