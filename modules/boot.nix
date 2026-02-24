{ config, lib, pkgs, ... }:

{
  boot = {

    loader = {
      systemd-boot = {
        enable = true;
        # Limit stored boot entries — without this, after ~50 rebuilds
        # your /boot partition fills up and nixos-rebuild switch fails.
        configurationLimit = 10;
        # Show the boot menu for 3 seconds so you can pick an older generation
        # if something goes wrong after an upgrade.
        editor = false; # disable boot entry editing (security hardening)
      };
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "ntfs" ];

    # Reduce boot verbosity — shows a clean Plymouth screen instead of walls of text
    # Comment these out if you want to see boot logs
    kernelParams = [ "quiet" "rd.systemd.show_status=false" ];
    consoleLogLevel = 3;
  };
}

