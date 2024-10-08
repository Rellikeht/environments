{pkgs ? import <nixpkgs> {}}: {
  defaultShell = packages:
    pkgs.mkShell {
      inherit packages;
      phases = [];
      shellHook = ''
      '';
    };
}
