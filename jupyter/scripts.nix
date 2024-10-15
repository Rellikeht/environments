{pkgs ? import <nixpkgs> {}}:
with pkgs; {
  serv =
    writeScriptBin "serv"
    ''exec jupyter server $@'';
  list =
    writeScriptBin "list"
    ''exec jupyter server list $@'';
  stop =
    writeScriptBin "stop"
    ''exec jupyter server stop $@'';
  juprun =
    writeScriptBin "lab"
    ''exec jupyter-lab --no-browser $@'';

  shell-hook = ''
    # pip install jupyterlab-vim jupyterlab-execute-time
  '';
}
