{pkgs ? import <nixpkgs> {}}: {
  devShells = {
    default = pkgs.mkShell {
      buildInputs = with pkgs; [
        arduino-cli
        arduino-language-server
        clang-tools
      ];
      shellHook = ''
      '';
    };
  };
}
