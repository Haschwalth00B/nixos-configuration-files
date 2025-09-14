{ config, pkgs, ... }:

{
  home.username = "haschwalth";
  home.homeDirectory = "/home/haschwalth";
  home.stateVersion = "24.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
      nrs = "sudo nixos-rebuild switch";
    };

    initExtra = ''
      export PS1='\[\e[2m\]󰭕\[\e[0;38;5;76m\]\u\[\e[32m\]@\[\e[38;5;31m\]\W\[\e[0m\] \\$ '
    '';
  };

  home.file.".config/bat/config".text = ''
    --theme="Nord"
    --style="numbers,changes,grid"
    --paging=auto
  '';

  home.file.".config/nvim".source = /home/haschwalth/dot_files/nvim;

  home.packages = with pkgs; [
    bat
  ];
}
