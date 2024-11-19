{ config, lib, ... }:

{
  environment.etc.prometheus-config = {
    source = ./etc/prometheus/prometheus.yml;
    target = "prometheus/prometheus.yml";
  };

  virtualisation = {
    oci-containers.containers = {
      opstack-garnet-op-geth = {
        image = "prom/prometheus";
        autoStart = true;
        volumes = [
          "/etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro"
          "prometheus-data:/prometheus:rw"
        ];
        labels = { 
          "traefik.enable" = "true";

          # HTTPS RPC
          "traefik.http.routers.prometheus.rule" = "Host(`metrics-dashboard.net.scetrov.live`) || Host(`metrics-dashboard-test.net.scetrov.live`)";
          "traefik.http.routers.prometheus.tls" = "true";
          "traefik.http.routers.prometheus.entrypoints" = "websecure";
          "traefik.http.routers.prometheus.service" = "prometheus-service";
          "traefik.http.services.prometheus-service.loadbalancer.server.port" = "8545";
        };
      };
    };
  };
}