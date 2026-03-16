# nix-server

My personal NixOS server configuration, managed entirely with [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager).

This is a fully declarative, reproducible setup running on a repurposed laptop (Intel Core i3 6th Gen · 12 GB RAM · 1 TB HDD) as a 24/7 home server.

---

## What this is

Instead of manually configuring a server and hoping it stays consistent, this repo *is* the server. Every package, service, user setting, and system option is declared in Nix. Rebuilding from scratch produces an identical result every time.

The entire system — from kernel parameters to shell aliases to editor plugins — is version-controlled here.

---

## Structure

```
.
├── flake.nix                 # Entry point — inputs and system definition
├── configuration.nix         # Root config, imports all modules
├── hardware-configuration.nix
├── modules/
│   ├── boot.nix              # systemd-boot, EFI
│   ├── networking.nix        # Static IP, firewall, network tools
│   ├── users.nix             # User accounts and groups
│   ├── packages.nix          # System-wide packages
│   ├── services.nix          # SSH, Tailscale, Samba, Avahi, cron
│   ├── security.nix          # SSH hardening, fail2ban, sudo policy
│   ├── power.nix             # CPU governor, ASPM power management
│   ├── virtualization.nix    # Docker with auto-prune
│   ├── monitoring.nix        # Netdata dashboard, btop, smartmontools
│   ├── maintenance.nix       # Nix GC, auto-upgrades, binary caches
│   ├── fonts.nix             # Nerd Fonts (MesloLGS, FiraCode, JetBrains)
│   └── shell.nix             # ZSH system config, Oh-My-Zsh, Powerlevel10k
└── home/
    ├── default.nix           # Home Manager root
    ├── packages.nix          # User-level packages (gh, glow, yazi, asciinema)
    ├── shell.nix             # ZSH + Bash — aliases, functions, fzf, zoxide
    ├── git.nix               # Git config, delta diffs, gh CLI
    ├── tools.nix             # bat, fzf, zoxide, eza, direnv, yazi
    ├── tmux.nix              # tmux with resurrect, continuum, catppuccin theme
    └── ssh.nix               # SSH client config, connection persistence
```

---

## Services running on this machine

These are all managed as Docker containers (via `docker-compose`) on top of the NixOS host:

| Service | Purpose |

|---|---|
| **Immich** | Self-hosted photo backup with ML-based face recognition and scene classification |
| **Home Assistant** | Home automation hub |
| **n8n** | Workflow automation (with Postgres backend) |
| **Pi-hole** | Network-wide DNS filtering and ad blocking |
| **Homepage** | Self-hosted dashboard for all services |
| **qBittorrent** | Torrent client |
| **Portainer** | Docker container management UI |

Network access: all services are behind **Tailscale** for secure remote access, with **Avahi mDNS** for local LAN discovery (`nix-server.local`).

---

## Key system features

**Declarative everything.** Packages, services, fonts, shell config — all in Nix. `sudo nixos-rebuild switch` applies the full desired state.

**Flakes with pinned inputs.** `nixpkgs` and `home-manager` are locked via `flake.lock`, so builds are reproducible across time.

**Home Manager integration.** User environment (shell, editor config, git, tools) is managed alongside the system config in the same flake, using `useGlobalPkgs` and `useUserPackages`.

**Power management.** Running on laptop hardware means ASPM (Active State Power Management) tuning and `schedutil` CPU governor to keep idle power consumption low.

**Netdata monitoring.** Real-time system metrics available at `http://nix-server.local:19999` on the local network.

**Automatic maintenance.** Weekly garbage collection (removes generations older than 14 days), weekly system upgrades at 3 AM Monday, automatic Docker image pruning.

---

## Shell environment

The ZSH setup (`home/shell.nix`) includes:

- **Powerlevel10k** prompt
- **zoxide** (`z`) for smart directory jumping
- **fzf** with Catppuccin Mocha colours and fd/bat integration
- **eza** replacing `ls` (icons, git status, tree view)
- **bat** replacing `cat` (Nord theme, syntax highlighting, man page rendering)
- **lazygit** and **lazydocker** for TUI git and container management
- NixOS-specific aliases (`nrs`, `nrt`, `nixclean`, `nixgen`, etc.)
- Docker aliases (`dkps`, `dsh` for fuzzy container shell entry)
- Shell functions: `mkcd`, `extract`, `ff` (fuzzy file open), `fcd`, `fco`, `serve`, `sysinfo`

---

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel Core i3 (6th Gen) |
| RAM | 12 GB |
| Storage | 1 TB HDD |
| Form factor | Repurposed laptop (lid closed, server mode) |
| Network | Wired Ethernet, static IP `192.168.1.34` |

The `services.logind` config ignores lid switch events so the machine runs headless continuously.

---

## Contribution to nixpkgs

While working with this setup I made a small upstream contribution: migrated the `vegur` package to use the `installFonts` setup hook instead of a manual install phase ([PR #498949](https://github.com/NixOS/nixpkgs/pull/498949)).

---

## Usage

```bash
# Apply configuration
sudo nixos-rebuild switch

# Test without activating
sudo nixos-rebuild test

# Upgrade and switch
sudo nixos-rebuild switch --upgrade

# Clean old generations
sudo nix-collect-garbage -d && sudo nix-store --optimise
```

> **Note:** `hardware-configuration.nix` is machine-specific and won't work on different hardware without regenerating via `nixos-generate-config`.

