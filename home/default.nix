{ config, pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./tools.nix
    ./tmux.nix
    ./ssh.nix
  ];

  home.username    = "haschwalth";
  home.homeDirectory = "/home/haschwalth";
  home.stateVersion  = "24.05";

  # ── Neovim config symlink ─────────────────────────────────────────────────

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/haschwalth/dot_files/nvim";

  # ── XDG base dirs ─────────────────────────────────────────────────────────
  xdg.enable = true;
}

