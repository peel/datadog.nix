# nix eval --json -f ./datadog/default.nix '' --show-trace | jq

let
    type = "file";
    service = "nginx";
    source = service;
    basePath = "/var/log/nginx";
in {
  imports = [
    ./datadog/config.nix
  ];
  datadog.integrations = {
    nginx = {
      logs = [
        { inherit type service source;
          path = "${basePath}/access.log";
          sourcecategory = "access";
        }
        { inherit type service source;
          path = "${basePath}/error.log";
          sourcecategory = "error";
        }
      ];
    };
    docker_daemon = {
      instances = [{
        url = "unix://var/run/docker.sock";
        new_tag_names = true;
      }];
    };
  };
}
