{
  pkgs ? import <nixpkgs> {},
  scripts ? import ./scripts.nix {inherit pkgs;},
}: rec {
  #  {{{
  b = builtins;
  python = pkgs.python312;
  pythonPackages = pkgs.python312Packages;
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
      default = scripts.lab;
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

  shell-hook =
    #  {{{
    scripts.shell-hook
    + ''
    ''; #  }}}
}
