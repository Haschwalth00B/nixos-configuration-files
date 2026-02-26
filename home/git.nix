{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user.name  = "haschwalth";
      user.email = "srivatsapoojary@gmail.com";

      # ── Core ──────────────────────────────────────────────────────────────
      init.defaultBranch = "main";
      pull.rebase        = false;
      core.editor        = "nvim";
      core.autocrlf      = "input";   # LF on commit, no conversion on checkout (Linux)
      core.whitespace    = "trailing-space,space-before-tab";

      # ── Better diffs ──────────────────────────────────────────────────────
      diff.algorithm     = "histogram";
      diff.colorMoved    = "default";  # highlight moved code blocks differently
      merge.conflictStyle = "zdiff3";  # shows the original (base) in conflict markers

      # ── Delta — syntax-highlighted diffs ──────────────────────────────────
      core.pager  = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      delta = {
        navigate    = true;    # n/N to jump between diff sections
        light       = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Nord";
      };

      # ── Pager tweaks ──────────────────────────────────────────────────────
      pager.branch = false;
      pager.tag    = false;


      # ── Rerere — remember conflict resolutions ────────────────────────────
      rerere.enabled = true;

      # ── Push behaviour ────────────────────────────────────────────────────
      push.autoSetupRemote = true;   # auto --set-upstream on first push

      # ── Aliases ───────────────────────────────────────────────────────────

      alias = {
        st           = "status -sb";
        co           = "checkout";
        br           = "branch";
        ci           = "commit";
        unstage      = "reset HEAD --";
        last         = "log -1 HEAD --stat";
        visual       = "log --graph --oneline --decorate --all";
        lg           = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        contributors = "shortlog --summary --numbered";
        amend        = "commit --amend --no-edit";
        wip          = "commit -am 'WIP'";
        undo         = "reset HEAD~1 --mixed";  # undo last commit, keep changes staged
        stash-all    = "stash push --include-untracked";
      };

      # ── Colours ───────────────────────────────────────────────────────────
      color.ui                  = "auto";
      color.branch.current      = "yellow reverse";
      color.branch.local        = "yellow";
      color.branch.remote       = "green";
      color.diff.meta           = "yellow bold";
      color.diff.frag           = "magenta bold";
      color.diff.old            = "red";
      color.diff.new            = "green";
      color.status.added        = "green";
      color.status.changed      = "yellow";
      color.status.untracked    = "cyan";
    };

    ignores = [
      # Editor artifacts
      "*~" "*.swp" "*.swo"
      ".idea/" ".vscode/" "*.iml"
      # OS artifacts
      ".DS_Store" "Thumbs.db"
      # Logs & build artefacts
      "*.log" "*.out"
      # Dependency dirs
      "node_modules/"
      # Python
      "__pycache__/" "*.pyc" "*.pyo" ".venv/" "*.egg-info/"
      # Rust
      "target/"
      # Go
      "vendor/"
      # Env / secrets
      ".env" ".env.local" ".envrc" ".direnv/"
      # Nix
      "result" "result-*"
    ];
  };

  # gh — GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor       = "nvim";
      prompt       = "enabled";
    };
  };
}

