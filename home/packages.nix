{ pkgs, ... }:
{
  # User-level packages — things only this user needs.
  # System-wide tools (git, neovim, docker, etc.) live in modules/packages.nix.
  home.packages = with pkgs; [
    # ── Shell / UX ────────────────────────────────────────────────────────────
    pfetch       # lightweight system info (used in welcome message)

    # ── Dev utilities ─────────────────────────────────────────────────────────
    gh           # GitHub CLI (pr, issue, repo management from terminal)
    glow         # render markdown in terminal
    yazi         # blazing-fast TUI file manager
    nix-output-monitor  # prettier nixos-rebuild output (use: nom-rebuild)

    # ── Misc ──────────────────────────────────────────────────────────────────
    asciinema    # record terminal sessions
  ];
}

