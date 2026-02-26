{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # ── Editors ───────────────────────────────────────────────────────────────
    neovim

    # ── Network / Transfer ────────────────────────────────────────────────────
    wget
    curl
    tailscale
    rsync          # fast file sync / backup
    sshfs          # mount remote dirs over SSH

    # ── File sharing ──────────────────────────────────────────────────────────
    samba

    # ── Terminal utilities ────────────────────────────────────────────────────
    tmux
    pfetch-rs
    ripgrep
    fd
    tree
    sl
    jq             # JSON processor
    yq-go          # YAML/TOML/XML processor (like jq for yaml)
    fzf            # fuzzy finder
    bat            # cat with syntax highlighting
    eza            # modern ls
    zoxide         # smarter cd
    delta          # better git diffs
    gdu            # fast disk usage analyser
    unzip
    zip
    p7zip
    file           # identify file types
    lsof           # list open files / ports
    strace         # trace system calls (debugging)
    pstree         # process tree

    # ── Development tools ─────────────────────────────────────────────────────
    git
    lazygit        # TUI git client
    gcc
    gnumake
    cmake
    pkg-config
    pciutils
    lshw
    gdb            # debugger
    hyperfine      # command-line benchmarking

    tokei          # count lines of code
    watchexec      # re-run commands on file changes
    entr           # run commands when files change (simpler alternative)
    just           # command runner (like make but better)
    direnv         # per-directory env vars

    # ── Programming languages ─────────────────────────────────────────────────
    go
    nodejs_24
    python3
    python312Packages.pip
    python313Packages.pip
    uv             # fast Python package manager (replaces conda)
    rustup         # Rust toolchain manager

    # ── Containers ────────────────────────────────────────────────────────────
    docker
    docker-compose
    dive           # inspect Docker image layers
    lazydocker     # TUI Docker manager

    # ── Web / content ─────────────────────────────────────────────────────────
    hugo
    code-server

    # ── Media / metadata ──────────────────────────────────────────────────────
    exiftool
    ffmpeg         # video/audio processing (useful even on server)

    # ── Misc ──────────────────────────────────────────────────────────────────
    tldr           # simplified man pages
    neofetch       # system info (alternative to pfetch)
  ];

  programs.firefox.enable = false;
}

