{pkgs ? import <nixpkgs> {}}: {
  devShells = {
    default = pkgs.mkShell {
      buildInputs = with pkgs;
        [
          (dhall.withPackages [
            dhall-grafana
          ])
          dhall-lsp-server

          dhall-nixpkgs
          dhall-nix

          dhall-json
          dhall-yaml
          dhall-docs
          dhall-bash
        ]
        ++ (
          with haskellPackages; [
            dhall-toml
            dhall-to-cabal
          ]
          # TODO what to do with that shit
          # ++ (
          # )
          # with dhallPackages; [
          #   Prelude
          #   dhall-grafana
          #   dhall-kuberneters
          #   dhall-cloudformation
          # ]
        );

      shellHook = ''
      '';
    };
  };
}
