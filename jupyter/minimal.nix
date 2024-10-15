{
  pkgs ? import <nixpkgs> {},
  scripts ? import ./scripts.nix {inherit pkgs;},
}: rec {
  #  {{{
  b = builtins;
  python = pkgs.python312;
  #  }}}

  python-packages = ps:
    with ps; [
      # {{{
      bpython # Because it gets broken when is not here
      notebook

      jupyter-console
      jupyter-core

      jupyterlab
      jupyterlab-lsp
      jupyterlab-execute-time
    ]; # }}}

  out-packages =
    # {{{
    (b.removeAttrs scripts ["shell-hook"])
    // {
      default = scripts.juprun;
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

  shell-hook =
    #  {{{
    scripts.shell-hook
    ++ ''
    ''; #  }}}
}
