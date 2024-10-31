{ config, ... }:

{
  environment.etc.traefik-static = {
    source = ./etc/traefik/traefik.toml;
    target = "traefik/traefik.toml";
  };

  environment.etc.traefik-dynamic = {
    source = ./etc/traefik/dynamic.toml;
    target = "traefik/dynamic.toml";
  };

  virtualisation = {
    oci-containers.containers = {
      reverse-proxy = {
        image = "traefik:v3.1";
        autoStart = true;
        ports = [
          "0.0.0.0:80:80"
          "0.0.0.0:443:443"
        ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "/var/lib/acme:/var/lib/acme:ro"
          "/etc/traefik/traefik.toml:/etc/traefik/traefik.toml:ro"
          "/etc/traefik/dynamic.toml:/etc/traefik/dynamic.toml:ro"
        ];
        labels = {
          "traefik.http.routers.api.rule" = "Host(`dashboard.web3.scetrov.live`)";
          "traefik.http.routers.api.service" = "api@internal";
          "traefik.http.routers.api.tls" = "true";
          "traefik.http.routers.api.entrypoints" = "websecure";
        };
      };
      whoami = {
        image = "traefik/whoami";
        autoStart = true;
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.whoami.rule" = "Host(`whoami.net.scetrov.live`)";
          "traefik.http.routers.whoami.tls" = "true";
        };
      };
    };
  };
}