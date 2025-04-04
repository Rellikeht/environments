{pkgs ? import <nixpkgs> {}}: let
  base = import ./minimal.nix {inherit pkgs;};
in
  with base; rec {
    # inherit defaultShell;
    inherit python pythonPackages;

    python-packages = ps:
    # {{{
      with ps; (
        base.python-packages ps
        ++ [
          # {{{
          nbconvert
        ] # }}}
      ); # }}}

    shell-packages =
      # {{{
      base.shell-packages
      ++ (with pkgs; [
        inkscape
        pandoc

        (texlive.combine {
          # {{{
          inherit
            (pkgs.texlive)
            tcolorbox
            environ
            pdfcol
            upquote
            adjustbox
            scheme-medium
            # scheme-small
            
            caption
            collectbox
            enumitem
            eurosym
            etoolbox
            jknapltx
            parskip
            pgf
            rsfs
            titling
            trimspaces
            ucs
            ulem
            ltxcmds
            infwarerr
            iftex
            kvoptions
            kvsetkeys
            float
            geometry
            amsmath
            fontspec
            unicode-math
            fancyvrb
            grffile
            hyperref
            booktabs
            soul
            ec
            ;
        }) # }}}
      ])
      ++ (with out-packages; []);

    out-packages =
      {} // base.out-packages; # }}}

    shell-hook =
      ''''
      + base.shell-hook;
  }
