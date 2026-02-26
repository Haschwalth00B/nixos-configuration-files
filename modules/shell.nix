{ config, pkgs, ... }:
{
  # ── ZSH system-wide enablement ────────────────────────────────────────────
  # Individual user config lives in home/shell.nix via Home Manager.
  # This module only handles what must be set at the system level.
  programs.zsh = {
    enable            = true;
    enableCompletion  = true;
    autosuggestions.enable    = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable  = true;
      plugins = [ "git" "sudo" "docker" "systemd" "colored-man-pages" ];
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # direnv — shell hook must be available system-wide
  programs.direnv = {
    enable           = true;
    silent           = true;
    nix-direnv.enable = true;   # makes nix-shell / flake shells instant
  };
}

