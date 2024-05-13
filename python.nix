{pkgs}: {
  python-packages = ps:
    with ps; [
      bpython
      pip
      python-lsp-server
      mypy
      pylsp-mypy
      pynvim
    ];

  shell-packages = with pkgs; [
    ruff
    pylyzer
  ];
}
