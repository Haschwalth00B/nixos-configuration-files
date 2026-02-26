{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # === EDITORS ===
    neovim
    # === NETWORK TOOLS ===
    wget
    curl
    tailscale
    # === SYSTEM MONITORING ===
    btop
    htop
    powertop
    # === FILE SHARING ===
    samba
    # === TERMINAL UTILITIES ===
    tmux
    pfetch-rs
    ripgrep
    tree
    sl
    # === DEVELOPMENT TOOLS ===
    git
    gcc
    pciutils
    lshw
    gnumake
    # === PROGRAMMING LANGUAGES ===
    go
    nodejs_24
    python3
    python312Packages.pip
    python313Packages.pip
    # === PYTHON ENVIRONMENT ===
    # conda and python312Packages.conda removed — conda-libmamba-solver is
    # broken in current nixos-unstable. Use uv instead (already included).
    uv
    # === CONTAINERIZATION ===

    docker
    docker-compose
    # === WEB & CONTENT ===
    hugo
    code-server
    # === MEDIA TOOLS ===
    exiftool
    # === ZSH ===
    # Nerd Fonts for Powerlevel10k

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    # === AI ===
    #claude-code
  ];
  programs.firefox.enable = false;
}

