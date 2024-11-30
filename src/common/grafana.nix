{ config, lib, ... }:

{
  # environment.etc.prometheus-config = {
  #   source = ./etc/prometheus/prometheus.yml;
  #   target = "prometheus/prometheus.yml";
  # };

  virtualisation = {
    oci-containers.containers = {
      grafana = {
        image = "grafana/grafana-oss";
        autoStart = true;
        volumes = [
          # "/etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro"
          "grafana-storage:/var/lib/grafana"
        ];
        labels = { 
          "traefik.enable" = "true";

          # HTTPS RPC
          "traefik.http.routers.grafana.rule" = "Host(`monitoring.net.scetrov.live`) || Host(`monitoring-test.net.scetrov.live`)";
          "traefik.http.routers.grafana.tls" = "true";
          "traefik.http.routers.grafana.entrypoints" = "websecure";
          "traefik.http.routers.grafana.service" = "grafana-service";
          "traefik.http.services.grafana-service.loadbalancer.server.port" = "3000";
        };
      };
    };
  };
}