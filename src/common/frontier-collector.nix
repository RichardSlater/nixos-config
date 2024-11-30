{ config, pkgs, ... }:

{
    systemd.timers."eve-frontier-smart-assemblies" = {
    wantedBy = [ "timers.target" ];
        timerConfig = {
        OnBootSec = "15m";
        OnUnitActiveSec = "15m";
        Unit = "eve-frontier-smart-assemblies.service";
        };
    };

    systemd.services."eve-frontier-smart-assemblies" = {
        script = ''
            /run/current-system/sw/bin/wget https://blockchain-gateway-nebula.nursery.reitnorf.com/smartassemblies --output-document=/home/richardsl/evefrontier/smartassemblies/`date +%s --utc`.json
        '';
        serviceConfig = {
            Type = "oneshot";
            User = "richardsl";
        };
    };
}