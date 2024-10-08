{
  inputs = {
    # {{{
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  }; # }}}

  outputs = {
    # {{{
    self,
    nixpkgs,
    flakeUtils,
    # }}}
  }: let
    # helpers {{{
    b = builtins;
    lib = nixpkgs.lib;
    #  }}}

    changeName = new: old:
    #  {{{
      if old == "default"
      then new
      else new + "-" + old; #  }}}

    rename = setName: attrs: let
      #  {{{
      alists =
        map
        (
          {
            name,
            value,
          }: {
            inherit name;
            value = let
              nlist = lib.attrsToList value;
              names = map (e: e.name) nlist;
              values = map (e: e.value) nlist;
              newNames = map (n: {name = changeName setName n;}) names;
              newValues = map (v: {value = v;}) values;
              alist =
                lib.zipListsWith (a: b: a // b)
                newNames
                newValues;
            in
              lib.listToAttrs alist;
          }
        ) (lib.attrsToList attrs);
    in
      lib.listToAttrs alists; #  }}}

    genMod = {
      name,
      value,
    }: system:
    #  {{{
    let
      file =
        if b.typeOf value == "path"
        then value
        else value.file;
      additional =
        if b.typeOf value == "path"
        then _: {}
        else value.additional;
    in
      rename name (import file (let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          inherit pkgs;
        }
        // (additional pkgs))); #  }}}
  in
    b.foldl' lib.recursiveUpdate
    {}
    (map (e: flakeUtils.lib.eachDefaultSystem (genMod e)) (
      #  {{{
      lib.attrsToList
      {
        nickel = ./nickel/default.nix;
        sysops = ./sysops/default.nix; # for labs on uni

        pluto = ./pluto/default.nix;
        ijulia = ./ijulia/default.nix;
        ipython_minimal = ./ipython/default.nix;

        ipython_mindata = {
          #  {{{
          file = ./ipython/default.nix;
          additional = pkgs: {
            jupyter-packages = import ./jupyterMinimal.nix {inherit pkgs;};
            additional-packages = with pkgs; [];
            additional-python = ps:
              with ps; [
                matplotlib
                numpy
                pandas
              ];
          };
        }; #  }}}

        ipython_full = {
          #  {{{
          file = ./ipython/default.nix;
          additional = pkgs: {
            jupyter-packages = import ./jupyter.nix {inherit pkgs;};
            additional-packages = with pkgs; [];
            additional-python = ps:
              with ps; [
                matplotlib
                numpy
                pandas
                sympy
              ];
          };
        }; #  }}}

        digital-images = {
          # for labs on uni {{{
          file = ./ipython/default.nix;
          additional = pkgs: {
            jupyter-packages = import ./jupyterMinimal.nix {inherit pkgs;};
            additional-packages = with pkgs; [];
            python = pkgs.python311;
            additional-python = ps:
              with ps; [
                matplotlib
                numpy
                opencv4
                scikit-image
              ];
          };
        }; #  }}}

        # ai-basics = {
        #   # for labs on uni {{{
        #   file = ./ipython/default.nix;
        #   additional = pkgs: {
        #     jupyter-packages = import ./jupyterMinimal.nix {inherit pkgs;};
        #     additional-packages = with pkgs; [];
        #     additional-python = ps:
        #       with ps; [
        #         matplotlib
        #         numpy
        #         scikit-learn
        #         missingno
        #         seaborn
        #       ];
        #   };
        # }; #  }}}

        #
      } #  }}}
    ));
}
