{ config, lib, ... }:

{
  environment.etc.erigon-ethereum-holesky = {
    source = ./etc/erigon-ethereum-holesky.toml;
    target = "erigon-ethereum-holesky.toml";
  };

  systemd.services.setup-erigon-data = {
    script = ''
      mkdir -p /var/lib/erigon-ethereum-holesky
      chmod 750 /var/lib/erigon-ethereum-holesky
      chown 100:1000 /var/lib/erigon-ethereum-holesky
    '';
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.services.podman-erigon-ethereum-holesky = {
    wantedBy = [ "multi-user.target" ];
    after = [ "setup-erigon-data.service" ];
    description = "Erigon Ethereum Holesky Node";
  };

  virtualisation = {
    oci-containers.containers = {
      erigon-ethereum-holesky = {
        image = "erigontech/erigon:latest";
        cmd = [ "--config" "/etc/erigon-ethereum-holesky.toml" ];
        autoStart = true;
        volumes = [
          "/var/lib/erigon-ethereum-holesky:/var/lib/erigon-ethereum-holesky:rw"
          "/etc/erigon-ethereum-holesky.toml:/etc/erigon-ethereum-holesky.toml"
        ];
        labels = {
          # HTTPS RPC
          "traefik.enable" = "true";
          "traefik.http.routers.erigon-ethereum-holesky-rpc.rule" = "Host(`eth-holesky-rpc.web3.scetrov.live`) || Host(`eth-holesky-rpc-test.web3.scetrov.live`)";
          "traefik.http.routers.erigon-ethereum-holesky-rpc.tls" = "true";
          "traefik.http.routers.erigon-ethereum-holesky-rpc.entrypoints" = "websecure";
          "traefik.http.routers.erigon-ethereum-holesky-rpc.service" = "erigon-holesky-rpc-service";
          "traefik.http.services.erigon-holesky-rpc-service.loadbalancer.server.port" = "8454";

          # TCP
          "traefik.tcp.routers.erigon-ethereum-holesky-snap.entrypoints" = "snap-tcp";
          "traefik.tcp.routers.erigon-ethereum-holesky-snap.rule" = "HostSNI(`*`)";
          "traefik.tcp.routers.erigon-ethereum-holesky-snap.service" = "erigon-holesky-snap";
          "traefik.tcp.services.erigon-holesky-snap.loadbalancer.server.port" = "42069";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth68.entrypoints" = "eth68-tcp";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth68.rule" = "HostSNI(`*`)";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth68.service" = "erigon-holesky-eth68";
          "traefik.tcp.services.erigon-holesky-eth68.loadbalancer.server.port" = "30303";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth67.entrypoints" = "eth67-tcp";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth67.rule" = "HostSNI(`*`)";
          "traefik.tcp.routers.erigon-ethereum-holesky-eth67.service" = "erigon-holesky-eth67";
          "traefik.tcp.services.erigon-holesky-eth67.loadbalancer.server.port" = "30304";
          "traefik.tcp.routers.erigon-ethereum-holesky-sentinel.entrypoints" = "sentinel-tcp";
          "traefik.tcp.routers.erigon-ethereum-holesky-sentinel.rule" = "HostSNI(`*`)";
          "traefik.tcp.routers.erigon-ethereum-holesky-sentinel.service" = "erigon-holesky-sentinel";
          "traefik.tcp.services.erigon-holesky-sentinel.loadbalancer.server.port" = "4001";
          
          # UDP
          "traefik.udp.routers.erigon-ethereum-holesky-snap.entrypoints" = "snap-udp";
          "traefik.udp.routers.erigon-ethereum-holesky-snap.service" = "erigon-holesky-snap";
          "traefik.udp.services.erigon-holesky-snap.loadbalancer.server.port" = "42069";
          "traefik.udp.routers.erigon-ethereum-holesky-eth68.entrypoints" = "eth68-udp";
          "traefik.udp.routers.erigon-ethereum-holesky-eth68.service" = "erigon-holesky-eth68";
          "traefik.udp.services.erigon-holesky-eth68.loadbalancer.server.port" = "30303";
          "traefik.udp.routers.erigon-ethereum-holesky-eth67.entrypoints" = "eth67-udp";
          "traefik.udp.routers.erigon-ethereum-holesky-eth67.service" = "erigon-holesky-eth67";
          "traefik.udp.services.erigon-holesky-eth67.loadbalancer.server.port" = "30304";
          "traefik.udp.routers.erigon-ethereum-holesky-sentinel.entrypoints" = "sentinel-udp";
          "traefik.udp.routers.erigon-ethereum-holesky-sentinel.service" = "erigon-holesky-sentinel";
          "traefik.udp.services.erigon-holesky-sentinel.loadbalancer.server.port" = "4000";
        };
      };
    };
  };
}