{pkgs}: {
  defaultShell = packages:
    pkgs.mkShell {
      inherit packages;
      phases = [];
      shellHook = '''';
    };
}
