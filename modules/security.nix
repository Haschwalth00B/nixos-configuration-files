{ config, lib, pkgs, ... }:
{
  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh.settings = {
    PasswordAuthentication = true;
    PermitRootLogin        = "no";
    ClientAliveInterval    = 120;
    ClientAliveCountMax    = 3;
  };

  # ── fail2ban (brute-force protection) ─────────────────────────────────────
  services.fail2ban = {
    enable   = true;
    maxretry = 5;
    bantime  = "1h";
  };

  # ── Sudo ──────────────────────────────────────────────────────────────────
  security.sudo = {
    enable             = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults timestamp_timeout=15
    '';
  };
}
