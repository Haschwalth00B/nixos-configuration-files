{ config, pkgs, ... }:
{
  # ── Bat — syntax-highlighted cat ─────────────────────────────────────────
  programs.bat = {
    enable = true;

    config = {
      theme  = "Nord";
      style  = "numbers,changes,grid";
      paging = "auto";
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
        "flake.nix:Nix"
        "*.nix:Nix"
      ];
    };
    # Extra syntax definitions / themes can go here
    extraPackages = with pkgs.bat-extras; [
      batdiff   # delta-powered bat diff
      batman    # bat-rendered man pages
      batpipe   # bat as a pager for other tools
    ];
  };


  # ── FZF — fuzzy finder ────────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
  };


  # ── Zoxide — smarter cd ───────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
  };

  # ── Eza — modern ls ───────────────────────────────────────────────────────
  programs.eza = {
    enable = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
    icons = "auto";
    git   = true;
    extraOptions = [
      "--group-directories-first"
      "--time-style=long-iso"
    ];
  };

  # ── Direnv — per-directory environment variables ──────────────────────────
  # Works with nix-direnv for instant nix shells (no more slow nix-shell)
  programs.direnv = {
    enable                = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
    nix-direnv.enable     = true;
    config = {
      global = {
        hide_env_diff = true;  # don't spam env var diffs on each cd
      };
    };
  };

  # ── Yazi — TUI file manager ───────────────────────────────────────────────
  programs.yazi = {
    enable               = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden  = true;
        sort_dir_first = true;
      };
    };
  };
}

