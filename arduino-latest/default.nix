{pkgs ? import <nixpkgs> {}}: {
  devShells = {
    default = pkgs.mkShell {
      buildInputs = with pkgs; [
        arduino-cli
        clang-tools
        picocom

        go
        (pkgs.writeScriptBin "arduino-ls-install" ''
          if ! [ -x "$GOPATH/bin/arduino-language-server" ]; then
              go install github.com/arduino/arduino-language-server@latest
          fi
        '')
      ];

      shellHook = ''
      '';
    };
  };
}
