{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  jupyter-packages ? import ../jupyterMinimal.nix {inherit pkgs;},
  python ? jupyter-packages.python,
  #  }}}
}: let
  #  {{{
  common-py = import ../python.nix {inherit pkgs;};
  #  }}}

  python-env =
    python.withPackages
    # {{{
    (ps:
      (jupyter-packages.python-packages ps)
      ++ (common-py.python-packages ps)
      ++ (with ps; [
        ipykernel
        ipython
      ])); # }}}

  shell-packages =
    # {{{
    jupyter-packages.shell-packages
    ++ common-py.shell-packages
    ++ [python-env]
    ++ (with pkgs; []); # }}}
in {
  devShells.default = utils.defaultShell shell-packages;
  packages = jupyter-packages.out-packages;

  apps.default = {
    #  {{{
    type = "app";
    program = "${jupyter-packages.out-packages.ipyrun}/bin/ipyrun";
  }; #  }}}
}
