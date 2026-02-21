{pkgs ? (import <nixpkgs>)}: let
  pico-sdk = pkgs.pico-sdk.override {withSubmodules = true;};
  pico-pinout-src = pkgs.fetchurl {
    url = "https://gabmus.org/pico_pinout";
    hash = "sha256-voVivSak1/waEuXj0E7G7QOn1Kc4nj9H1fxbSaFss1A=";
  };
  pico-pinout = pkgs.writeScriptBin "pico-pinout" ''
    less --quit-if-one-screen --raw-control-chars "${pico-pinout-src}"
  '';
in {
  devShells = {
    default = pkgs.mkShell {
      buildInputs = [
        pico-sdk
        pico-pinout
        (pkgs.writeScriptBin "pioasm" ''
          exec ${pico-sdk}/lib/pico-sdk/tools/pioasm/build/pioasm
        '')
      ];
      shellHook = ''
        export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk
      '';
    };

    full = pkgs.mkShell {
      buildInputs =
        [
          pico-sdk
          pico-pinout
          (pkgs.writeScriptBin "pioasm" ''
            exec ${pico-sdk}/lib/pico-sdk/tools/pioasm/build/pioasm
          '')
        ]
        ++ (
          with pkgs; [
            cmake
            gcc-arm-embedded
            libusb1
            picotool
          ]
        );
      shellHook = ''
        export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk
      '';
    };
  };
}
