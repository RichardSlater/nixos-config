{ config, ... }:

{
  boot.kernel.sysctl = {
    # allow unpriveledge ports < 1024.
    # ref: https://ar.al/2022/08/30/dear-linux-privileged-ports-must-die/
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true; # alias docker = podman
      dockerSocket.enable = true; # enable to socket for containers to introspect other containers
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      autoPrune = {
        # have a tidy up every week
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    oci-containers.backend = "podman";
  };

  networking.firewall.enable = true; # DANGEROUS
  services.openssh.openFirewall = true;

  # allow for DNS across the podman[0-9] interface
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  # forward ports to traefik
  networking.firewall = {
    allowedTCPPorts = [ 22 80 443 2069 4000 4001 9003 7300 30303 30304 39393 42069 ];
  };
}