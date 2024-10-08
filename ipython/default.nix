{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  jupyter-packages ? import ../jupyterMinimal.nix {inherit pkgs;},
  additional-packages ? [],
  additional-python ? _: [],
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
      ++ (with ps;
        [ipykernel ipython]
        ++ (additional-python ps))); # }}}

  shell-packages =
    # {{{
    jupyter-packages.shell-packages
    ++ common-py.shell-packages
    ++ [python-env]
    ++ additional-packages
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
