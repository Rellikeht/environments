{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils/utils.nix {inherit pkgs;},
  jupyter-packages ? import ../jupyter/minimal.nix {inherit pkgs;},
  additional-packages ? [],
  additional-python ? _: [],
  python ? jupyter-packages.python,
  shellFunc ? utils.hookShell,
  #  }}}
}: let
  #  {{{
  common-py = import ../utils/python.nix {inherit pkgs;};
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
  devShells.default =
    shellFunc shell-packages
    (
      jupyter-packages.shell-hook
      + ''''
    );

  packages = jupyter-packages.out-packages;

  apps.default = {
    #  {{{
    type = "app";
    program = "${jupyter-packages.out-packages.lab}/bin/lab";
  }; #  }}}
}
