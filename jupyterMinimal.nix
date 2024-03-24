{pkgs}: rec {
  python-packages = ps:
    with ps; [
      notebook
      jupyter-console
      jupyter-core
      jupyterlab
      jupyterlab-lsp
    ];

  shell-packages =
    (with pkgs; [
      ])
    ++ (with out-packages; [
      serv
      list
      stop
    ]);

  defaultShell = packages:
    pkgs.mkShell {
      inherit packages;
      phases = [];
      shellHook = '''';
    };

  out-packages = {
    serv = pkgs.writeScriptBin "serv" ''jupyter server $@'';
    list = pkgs.writeScriptBin "list" ''jupyter server list'';
    stop = pkgs.writeScriptBin "stop" ''jupyter server stop'';
  };
}
