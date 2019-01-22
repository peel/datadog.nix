let
  pkgs = import <nixpkgs> {};
  sanitize =
    with pkgs;
    configuration:
    builtins.getAttr (builtins.typeOf configuration) {
        bool = configuration;
        int = configuration;
        string = configuration;
        list = map sanitize configuration;
        set = lib.mapAttrs
          (lib.const sanitize)
          (lib.filterAttrs (name: value: name != "_module" && value != null) configuration);
      };
      
  result =
    with pkgs;
    with lib;
    evalModules {
      modules = [ { imports = [ ../datadog.nix ]; } ];
    };
in (sanitize result).config.integrations
