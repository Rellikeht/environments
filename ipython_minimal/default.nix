{
  #  {{{
  pkgs ? import <nixpkgs> {},
  utils ? import ../utils.nix {inherit pkgs;},
  #  }}}
}: let
  #  {{{
  common-jup = import ../jupyterMinimal.nix {inherit pkgs;};
  common-py = import ../python.nix {inherit pkgs;};
  #  }}}

  python =
    pkgs.python311.withPackages
    # {{{
    (ps:
      (common-jup.python-packages ps)
      ++ (common-py.python-packages ps)
      ++ (with ps; [
        ipykernel
        ipython
      ])); # }}}

  shellPackages =
    # {{{
    common-jup.shell-packages
    ++ common-py.shell-packages
    ++ [python]
    ++ (with pkgs; []); # }}}
in {
  devShells.default = utils.defaultShell shellPackages;
  packages = common-jup.out-packages;

  apps.default = {
    #  {{{
    type = "app";
    program = "${common-jup.out-packages.ipyrun}/bin/ipyrun";
  }; #  }}}
}
