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
  lab =
    writeScriptBin "lab"
    ''exec jupyter-lab --no-browser $@'';

  shell-hook = ''
    # uv install jupyterlab-vim jupyterlab-execute-time
  '';
}
