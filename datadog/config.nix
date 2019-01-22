{ config, lib, ... }:
with lib;
let
  cfg = config.datadog.integrations;
in {
  options.integrations = mkOption {
    type = with types; attrsOf attrs;
    default = {};
    description = "provider, basically APIs";
  };
  options.datadog.integrations = mkOption {
    default = {};
    type =  with types; attrsOf (submodule ({
      options = {
        init_config = mkOption {
          type = with types; str;
          default = "";
          example = "";
          description = ''
          '';
        };
        instances = mkOption {
          type = with types; listOf attrs;
          default = [];
          example = "[]";
          description = ''
          '';
        };
        logs = mkOption {
          type = with types; listOf attrs;
          default = [];
          example = "[]";
          description = ''
          '';
        };
      };
    }));
  };
  
  config = {
    integrations = 
       mapAttrs (name: configuration: {
          init_config = "";
          inherit (configuration) instances logs;
      }) cfg;
    };
}
