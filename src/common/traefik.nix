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

  networking.firewall.allowedTCPPorts = [ 22 80 443 42069 30303 30304 4001 39393 9003 7300 ];
  networking.firewall.allowedUDPPorts = [ 42069 30303 30304 4000 39393 9003 ];

  virtualisation = {
    oci-containers.containers = {
      reverse-proxy = {
        image = "traefik:latest";
        autoStart = true;
        ports = [
          "0.0.0.0:80:80/tcp"
          "0.0.0.0:443:443/tcp"
          "0.0.0.0:42069:42069/tcp"
          "0.0.0.0:42069:42069/udp"
          "0.0.0.0:30303:30303/tcp"
          "0.0.0.0:30303:30303/udp"
          "0.0.0.0:30304:30304/tcp"
          "0.0.0.0:30304:30304/udp"
          "0.0.0.0:4000:4000/udp"
          "0.0.0.0:4001:4001/tcp"
        ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "/var/lib/acme:/var/lib/acme:ro"
          "/etc/traefik/traefik.toml:/etc/traefik/traefik.toml:ro"
          "/etc/traefik/dynamic.toml:/etc/traefik/dynamic.toml:ro"
        ];
        labels = {
          "traefik.http.routers.api.rule" = "Host(`dashboard.web3.scetrov.live`) || Host(`dashboard-test.web3.scetrov.live`)";
          "traefik.http.routers.api.service" = "api@internal";
          "traefik.http.routers.api.tls" = "true";
          "traefik.http.routers.api.entrypoints" = "websecure";
        };
      };
    };
  };
}