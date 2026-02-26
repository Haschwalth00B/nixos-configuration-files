{ ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        compression         = true;

      };
    };

    extraConfig = ''
      ControlMaster auto
      ControlPath   ~/.ssh/cm_%r@%h:%p
      ControlPersist 10m
    '';
  };
}
