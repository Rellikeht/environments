{pkgs ? import <nixpkgs> {}}: rec {
  python = pkgs.python312;

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

  out-packages = rec {
    # {{{
    serv =
      pkgs.writeScriptBin "serv"
      ''jupyter server $@'';
    list =
      pkgs.writeScriptBin "list"
      ''jupyter server list'';
    stop =
      pkgs.writeScriptBin "stop"
      ''jupyter server stop'';
    juprun =
      pkgs.writeScriptBin "juprun"
      ''exec jupyter-lab --no-browser'';
    default = juprun;
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

  shell-hook = ''
    # pip install jupyterlab-vim jupyterlab-execute-time
  '';
}
