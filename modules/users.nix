{ config, lib, pkgs, ... }:

{
  users.users.haschwalth = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    
    # User-specific packages
    packages = with pkgs; [
      tree
      neovim
      curl
      wget
      nodejs_24
    ];
  };
}
