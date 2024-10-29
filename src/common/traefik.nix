{ config, ... }:

{
  environment.etc.traefik = {
    source = ./traefik.toml;
    target = "traefik/traefik.toml";
  };

  virtualisation = {
    oci-containers.containers = {
      reverse-proxy = {
        image = "traefik:v3.1";
        autoStart = true;
        cmd = [ "--providers.docker" "--providers.file.filename=/etc/traefik/traefik.toml" ];
        ports = [
          "0.0.0.0:80:80"
          "0.0.0.0:443:443"
          "0.0.0.0:8080:8080"
        ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
          "/var/lib/acme:/var/lib/acme:ro"
          "/etc/traefik/traefik.toml:/etc/traefik/traefik.toml:ro"
        ];
      };
      whoami = {
        image = "traefik/whoami";
        autoStart = true;
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.whoami.rule" = "Host(`whoami.docker.localhost`)";
          "traefik.http.routers.whoami.tls" = "true";
        };
      };
    };
  };
}