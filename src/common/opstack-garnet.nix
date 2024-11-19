{ config, lib, ... }:

{
  environment.etc.opstack-garnet-l2-genesis-json = {
    source = ./etc/opstack-garnet/l2-genesis.json;
    target = "opstack-garnet/l2-genesis.json";
  };

  environment.etc.opstack-garnet-rollup-json = {
    source = ./etc/opstack-garnet/rollup.json;
    target = "opstack-garnet/rollup.json";
  };

  environment.etc.run-consensus-layer-sh = {
    source = ./etc/opstack-garnet/run-consensus-layer.sh;
    target = "opstack-garnet/run-consensus-layer.sh";
  };

  environment.etc.run-excution-layer-sh = {
    source = ./etc/opstack-garnet/run-execution-layer.sh;
    target = "opstack-garnet/run-execution-layer.sh";
  };

  systemd.services.setup-opstack-data = {
    script = ''
      mkdir -p /var/lib/opstack-garnet/config
      mkdir -p /var/lib/opstack-garnet/data
      cp /etc/opstack-garnet/* /var/lib/opstack-garnet/config/
      chmod -R 750 /var/lib/opstack-garnet
      chown -R 100:1000 /var/lib/opstack-garnet
    '';
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
    };
  };

  virtualisation = {
    oci-containers.containers = {
      opstack-garnet-op-geth = {
        image = "us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth:v1.101315.2";
        entrypoint = "/config/run-execution-layer.sh";
        autoStart = true;
        volumes = [
          "/var/lib/opstack-garnet/config/:/config:ro"
          "/var/lib/opstack-garnet/data:/data:rw"
        ];
        labels = { 
          "traefik.enable" = "true";

          # HTTPS RPC
          "traefik.http.routers.opstack-garnet-op-geth-rpc.rule" = "Host(`garnet-rpc.web3.scetrov.live`) || Host(`garnet-rpc-test.web3.scetrov.live`)";
          "traefik.http.routers.opstack-garnet-op-geth-rpc.tls" = "true";
          "traefik.http.routers.opstack-garnet-op-geth-rpc.entrypoints" = "websecure";
          "traefik.http.routers.opstack-garnet-op-geth-rpc.service" = "opstack-garnet-op-geth-service";
          "traefik.http.services.opstack-garnet-op-geth-service.loadbalancer.server.port" = "8545";

          # HTTPS WSS
          "traefik.http.routers.opstack-garnet-op-geth-rpcws.rule" = "Host(`garnet-rpcws.web3.scetrov.live`) || Host(`garnet-rpcws-test.web3.scetrov.live`)";
          "traefik.http.routers.opstack-garnet-op-geth-rpcws.tls" = "true";
          "traefik.http.routers.opstack-garnet-op-geth-rpcws.entrypoints" = "websecure";
          "traefik.http.routers.opstack-garnet-op-geth-rpcws.service" = "opstack-garnet-op-geth-ws-service";
          "traefik.http.services.opstack-garnet-op-geth-ws-service.loadbalancer.server.port" = "8546";
        };
      };
      opstack-garnet-op-node = {
        image = "us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node:v1.8.0";
        entrypoint = "/config/run-consensus-layer.sh";
        autoStart = true;
        volumes = [
          "/var/lib/opstack-garnet/config/:/config:ro"
          "/var/lib/opstack-garnet/data:/data:rw"
        ];
        labels = {
          # TCP
          "traefik.tcp.routers.opstack-garnet-op-node-p2p-tcp.entrypoints" = "op-node-p2p-tcp";
          "traefik.tcp.routers.opstack-garnet-op-node-p2p-tcp.rule" = "HostSNI(`*`)";
          "traefik.tcp.routers.opstack-garnet-op-node-p2p-tcp.service" = "op-node-p2p";
          "traefik.tcp.services.op-node-p2p.loadbalancer.server.port" = "9003";

          # TCP
          "traefik.udp.routers.opstack-garnet-op-node-p2p-udp.entrypoints" = "op-node-p2p-udp";
          "traefik.udp.routers.opstack-garnet-op-node-p2p-udp.service" = "op-node-p2p";
          "traefik.udp.services.op-node-p2p.loadbalancer.server.port" = "9003";
        };
      };
    };
  };
}