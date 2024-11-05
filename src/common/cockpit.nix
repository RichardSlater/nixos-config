{ config, pkgs, ... }:

{
  environment.etc = {
    cockpit-cert = {
      source = "/var/lib/acme/scetrov.live/fullchain.pem";
      target = "cockpit/ws-certs.d/10-scetrov-live.crt";
      mode = "0300";
    };
    cockpit-key = {
      source = "/var/lib/acme/scetrov.live/key.pem";
      target = "cockpit/ws-certs.d/10-scetrov-live.key";
      mode = "0300";
    };
  };

  services.cockpit = {
    enable = true;
    port = 8880;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
      };
    };
  };
}