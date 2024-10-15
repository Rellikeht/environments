{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  julia ? pkgs.julia-bin,
  jupyter ? import ../jupyter/utils.nix {inherit pkgs;},
  #  }}}
}: let
  ijulia-run =
    pkgs.writeScriptBin "ijulia"
    # {{{
    ''
      exec julia -e '
        using Pkg
        # Pkg.activate(".")
        if !haskey(Pkg.project().dependencies, "IJulia")
          Pkg.add("IJulia")
        end
        using IJulia
        IJulia.jupyterlab(dir=pwd())
      ' $@
    ''; # }}}

  shell-Packages =
    # {{{
    jupyter.shell-packages
    ++ [julia]
    ++ (jupyter.python-packages pkgs.python311Packages)
    ++ [ijulia-run];
  # }}}
in {
  #  {{{

  packages =
    {default = ijulia-run;}
    // jupyter.out-packages;

  devShells = {default = utils.defaultShell shell-Packages;};

  apps = {
    # {{{
    default = {
      type = "app";
      program = "${ijulia-run}/bin/ijulia";
    };
  }; # }}}
}
#  }}}

