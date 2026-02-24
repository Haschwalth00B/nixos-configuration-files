{ config, lib, pkgs, ... }:

{
  users.users.haschwalth = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" ];
    shell        = pkgs.zsh;
    # Packages already provided system-wide via packages.nix are not repeated here.
    # Add truly user-specific packages below if needed.
    packages = with pkgs; [
    ];
  };
}

