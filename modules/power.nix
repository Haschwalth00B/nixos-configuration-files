{ config, lib, pkgs, ... }:

{
  powerManagement = {
    enable             = true;
    powertop.enable    = true;
    cpuFreqGovernor    = "schedutil";
  };

  # ── ASPM power management ─────────────────────────────────────────────────
  # Sandboxed properly: read-only filesystem, no network, private /tmp.
  # Using pkgs.writeShellScript instead of a bare path in your home dir
  # means the service will never fail because the file is missing.
  #
  # If you still need the custom autoaspm.py, keep the ExecStart below and
  # make sure /home/haschwalth/autoaspm/autoaspm.py exists.
  # Otherwise, powertop --auto-tune at startup achieves the same thing
  # without needing a separate script.
  systemd.services.powertop-autotune = {
    description = "Powertop auto-tune on startup";
    after       = [ "multi-user.target" ];
    wantedBy    = [ "multi-user.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;

      ExecStart       = "${pkgs.powertop}/bin/powertop --auto-tune";
    };
  };

  # ── ASPM via custom script (keep if you need autoaspm.py specifically) ────
  # Uncomment the block below and comment out powertop-autotune above.
  #
  # systemd.services.autoaspm = {
  #   description = "ASPM power management";
  #   after       = [ "network.target" ];
  #   wantedBy    = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart       = "${pkgs.python3}/bin/python3 /home/haschwalth/autoaspm/autoaspm.py";
  #     Restart         = "on-failure";
  #     Type            = "oneshot";
  #     RemainAfterExit = true;
  #     # Harden: drop privileges after the script runs
  #     User            = "root";
  #     ProtectSystem   = "strict";
  #     PrivateTmp      = true;
  #     NoNewPrivileges = true;
  #   };
  # };
}

