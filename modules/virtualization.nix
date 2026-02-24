{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable    = true;
    autoPrune = {
      enable = true;
      dates  = "weekly";
      flags  = [ "--all" ];  # also prune unused images, not just dangling ones
    };

    # Configure the Docker daemon
    daemon.settings = {
      # Log rotation — without this, container logs grow unbounded and fill /
      log-driver  = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };

      # Store layers efficiently
      storage-driver = "overlay2";
    };
  };
}

