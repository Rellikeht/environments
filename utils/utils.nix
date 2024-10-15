{pkgs ? import <nixpkgs> {}}: rec {
  hookShell = packages: hook:
    pkgs.mkShell {
      inherit packages;
      phases = [];
      shellHook = hook;
    };

  defaultShell = packages: hookShell packages "";
}
