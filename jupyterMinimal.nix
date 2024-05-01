{pkgs}: rec {
  python-packages = ps:
    with ps; [
      bpython # Because it gets broken when is not here
      notebook
      jupyter-console
      jupyter-core
      jupyterlab
      jupyterlab-lsp
    ];

  shell-packages =
    (with pkgs; [])
    ++ (with out-packages; [
      serv
      list
      stop
    ]);

  out-packages = {
    serv = pkgs.writeScriptBin "serv" ''jupyter server $@'';
    list = pkgs.writeScriptBin "list" ''jupyter server list'';
    stop = pkgs.writeScriptBin "stop" ''jupyter server stop'';
  };
}
