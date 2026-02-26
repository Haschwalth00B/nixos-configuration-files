{ config, lib, pkgs, ... }:
{
  # ── System monitoring packages ────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    btop          # modern TUI resource monitor
    htop          # classic TUI process viewer
    powertop      # power consumption analyser
    lm_sensors    # CPU/hardware temperature sensors
    smartmontools # disk health (S.M.A.R.T.)
    iotop         # disk I/O per process
    nethogs       # network bandwidth per process
    bandwhich     # real-time bandwidth by process / connection
    duf           # modern df — pretty disk usage overview
    ncdu          # interactive disk usage browser
  ];


  # ── Netdata — real-time web dashboard (http://localhost:19999) ────────────
  services.netdata = {
    enable = true;
    config = {
      global = {
        "update every"  = 2;   # seconds between data collection
        "memory mode"   = "ram";
      };
    };
  };

  # ── Systemd journal tweaks ────────────────────────────────────────────────
  services.journald.extraConfig = ''

    SystemMaxUse=500M
    MaxRetentionSec=30day
  '';
}

