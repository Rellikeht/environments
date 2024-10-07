{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  #  }}}
}: let
  #  {{{
  common = import ../jupyter.nix {inherit pkgs;};
  julia = pkgs.julia-bin;
  #  }}}

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

  shellPackages =
    # {{{
    common.shell-packages
    ++ [julia]
    ++ (common.python-packages pkgs.python311Packages)
    ++ [ijulia-run];
  # }}}
in {
  #  {{{

  packages =
    {default = ijulia-run;}
    // common.out-packages;

  devShells = {default = utils.defaultShell shellPackages;};

  apps = {
    # {{{
    default = {
      type = "app";
      program = "${ijulia-run}/bin/ijulia";
    };
  }; # }}}
}
#  }}}

