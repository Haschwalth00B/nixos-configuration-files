{ ... }:
{
  programs.ssh = {
    enable = true;

    # ── Global defaults ────────────────────────────────────────────────────
    serverAliveInterval = 60;   # send keepalive every 60s
    serverAliveCountMax = 3;    # drop after 3 missed keepalives
    compression         = true;
    addKeysToAgent      = "yes";

    extraConfig = ''

      # Use multiplexing for faster repeated connections to the same host
      ControlMaster auto
      ControlPath   ~/.ssh/cm_%r@%h:%p
      ControlPersist 10m
    '';

    # ── Host entries ─────────────────────────────────────────────────────────
    # Add your frequently accessed hosts here.
    # Example:
    # matchBlocks = {
    #   "myserver" = {
    #     hostname     = "192.168.1.x";
    #     user         = "haschwalth";
    #     identityFile = "~/.ssh/id_ed25519";
    #   };
    # };
  };
}

