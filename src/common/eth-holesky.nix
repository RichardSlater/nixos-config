{ config, ... }:

{
  virtualisation = {
    oci-containers.containers = {
      erigon-eth-holesky = {
        image = "erigontech/erigon:v2.60.9";
        autoStart = true;
        workDir = "/var/lib/erigon-eth-holesky";
        volumes = [
          ":/etc/traefik/dynamic.toml:ro"
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