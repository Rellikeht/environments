{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils/utils.nix {inherit pkgs;},
}: let
  julia = pkgs.julia-bin;

  run =
    pkgs.writeScriptBin "pluto"
    # {{{
    ''
      exec julia -e '
      using Pkg
      # Pkg.activate(".")
      if !haskey(Pkg.project().dependencies, "Pluto")
        Pkg.add("Pluto")
      end

      using Pluto
      Pluto.run(
          auto_reload_from_file=true,
          launch_browser=false
      )
      ' $@
    ''; # }}}

  progs =
    # {{{
    [
      julia
    ]
    ++ (with pkgs; [
      bashInteractive
    ]); # }}}
in rec {
  devShells = {
    # {{{
    default = utils.defaultShell (progs ++ [run]);
  }; # }}}

  packages = {
    # {{{
    default = run;
  }; # }}}

  apps = {
    # {{{
    default = {
      type = "app";
      program = "${run}/bin/pluto";
    };
  }; # }}}
}
