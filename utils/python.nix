{pkgs ? import <nixpkgs> {}}: {
  python-packages = ps:
    with ps; [
      #  {{{
      bpython
      pynvim
      uv

      python-lsp-server
      mypy
      pylsp-mypy

      types-requests
    ]; #  }}}

  shell-packages = with pkgs; [
    #  {{{
    ruff
    pylyzer
  ]; #  }}}
}
