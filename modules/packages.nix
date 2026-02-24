{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Editors ───────────────────────────────────────────────────────────────
    neovim

    # ── Network tools ─────────────────────────────────────────────────────────
    wget
    curl
    tailscale

    # ── System monitoring ─────────────────────────────────────────────────────
    btop
    htop
    powertop

    # ── File sharing ──────────────────────────────────────────────────────────
    samba

    # ── Terminal utilities ────────────────────────────────────────────────────
    tmux
    pfetch-rs
    ripgrep
    tree
    sl

    # ── Development tools ─────────────────────────────────────────────────────
    git
    gcc
    pciutils
    lshw
    gnumake

    # ── Programming languages ─────────────────────────────────────────────────
    go
    nodejs_24
    python3

    # ── Python environment ────────────────────────────────────────────────────
    # Using uv as the modern Python package/env manager.
    # conda was removed – it currently fails to build on nixos-unstable
    # (conda-libmamba-solver missing msgpack/requests/zstandard at runtime).
    # Use `uv venv` / `uv pip` instead; it's faster and works perfectly here.
    uv

    # ── Containerisation ──────────────────────────────────────────────────────
    docker
    docker-compose

    # ── Web & content ─────────────────────────────────────────────────────────
    hugo
    code-server

    # ── Media tools ───────────────────────────────────────────────────────────
    exiftool

    # ── AI (uncomment when ready) ─────────────────────────────────────────────
    # claude-code
  ];

  programs.firefox.enable = false;
}

