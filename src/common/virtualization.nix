{ config, ... }:

{
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
    };

    oci-containers.backend = "podman";

    oci-containers.containers = {
      nginxdemos-hello = {
        image = "nginxdemos/hello";
        autoStart = true;
        ports = [ "0.0.0.0:8081:80" ];
      };
    };
  };
}