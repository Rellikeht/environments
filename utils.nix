{pkgs}: rec {
  defaultShell = packages:
    pkgs.mkShell {
      inherit packages;
      phases = [];
      shellHook = '''';
    };
}
