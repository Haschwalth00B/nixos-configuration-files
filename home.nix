{ config, pkgs, ... }:
{
  home.username = "haschwalth";
  home.homeDirectory = "/home/haschwalth";
  home.stateVersion = "24.05";

  # User packages
  home.packages = with pkgs; [
    # Shell enhancements
    bat
    fzf
    eza
    ripgrep
    fd
    zoxide
    pfetch

    # System utilities
    htop
    btop
    tree

    # Development tools
    tldr
    jq
  ];

  # ============================================================================
  # ZSH
  # ============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];

    history = {
      size = 10000;
      save = 20000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # NixOS Management
      nrs   = "sudo nixos-rebuild switch";
      nrt   = "sudo nixos-rebuild test";
      nrb   = "sudo nixos-rebuild boot";
      nrsu  = "sudo nixos-rebuild switch --upgrade";
      nrv   = "sudo nixos-rebuild switch --show-trace";

      # NixOS Configuration
      nixedit  = "sudo $EDITOR /etc/nixos/configuration.nix";
      nixcd    = "cd /etc/nixos";
      nixlist  = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nixroll  = "sudo nixos-rebuild switch --rollback";

      # Nix Package Management
      nixsearch = "nix search nixpkgs";
      nixshell  = "nix-shell -p";

      # System Maintenance
      nixgc    = "sudo nix-collect-garbage -d";
      nixopt   = "sudo nix-store --optimise";
      nixclean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
      nixrepair = "sudo nix-store --verify --check-contents --repair";

      # eza (ls replacements)
      ls  = "eza --icons";
      ll  = "eza -lah --icons --git";
      la  = "eza -A --icons";
      l   = "eza --icons";
      lt  = "eza --tree --level=2 --icons";
      llt = "eza --tree --level=3 --icons --git -l";

      # Git
      g   = "git";
      gs  = "git status";
      ga  = "git add";
      gaa = "git add --all";
      gc  = "git commit";
      gcm = "git commit -m";
      gp  = "git push";
      gpl = "git pull";
      gl  = "git log --oneline --graph --decorate";
      gla = "git log --oneline --graph --decorate --all";
      gd  = "git diff";
      gds = "git diff --staged";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb  = "git branch";
      gba = "git branch -a";

      # Better alternatives
      grep = "rg";
      find = "fd";
      top  = "btop";
      cd   = "z";

      # Utility
      df   = "df -h";
      du   = "du -h";
      free = "free -h";
      ps   = "ps aux";

      # Navigation
      ".."   = "cd ..";
      "..."  = "cd ../..";
      "...." = "cd ../../..";

      # Quick edits
      zshrc = "$EDITOR ~/.zshrc";
      vimrc = "$EDITOR ~/.config/nvim/init.lua";

      fetch = "pfetch";
    };

    initExtra = ''
      # Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Zoxide
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      # FZF
      if command -v fzf-share >/dev/null 2>&1; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}' 2>/dev/null"
      export FZF_DEFAULT_COMMAND="${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # Pfetch
      export PF_INFO="ascii title os host kernel uptime pkgs memory shell editor wm palette"
      export PF_ASCII="nixos"
      export PF_COL1=4
      export PF_COL2=6
      export PF_COL3=7
      export PF_ALIGN="9"
      export PF_SEP=":"

      # BTW function
      btw() {
        clear
        echo ""
        pfetch
        echo ""
        echo "  \033[1;36m╭─────────────────────────────────╮\033[0m"
        echo "  \033[1;36m│\033[0m  \033[1;34m❄\033[0m  \033[1mI use NixOS btw\033[0m \033[1;34m😎\033[0m        \033[1;36m│\033[0m"
        echo "  \033[1;36m╰─────────────────────────────────╯\033[0m"
        echo ""
      }

      # Create dir and cd into it
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Extract any archive
      extract() {
        if [ -f "$1" ] ; then
          case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tar.xz)   tar xJf "$1"    ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.rar)      unrar e "$1"    ;;
            *.gz)       gunzip "$1"     ;;
            *.tar)      tar xf "$1"     ;;
            *.tbz2)     tar xjf "$1"    ;;
            *.tgz)      tar xzf "$1"    ;;
            *.zip)      unzip "$1"      ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1"       ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Fuzzy file search
      ff() {
        ${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git . "''${1:-.}" | \
          ${pkgs.fzf}/bin/fzf --preview 'bat --color=always {}' --preview-window=right:60%
      }

      # Fuzzy cd
      fcd() {
        local dir
        dir=$(${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git . "''${1:-.}" | \
          ${pkgs.fzf}/bin/fzf --preview 'eza --tree --level=1 --icons {}' --preview-window=right:60%)
        [ -n "$dir" ] && cd "$dir"
      }

      # Git fuzzy checkout
      fco() {
        local branch
        branch=$(git branch --all | grep -v HEAD | sed "s/.* //" | \
          sed "s#remotes/[^/]*/##" | sort -u | ${pkgs.fzf}/bin/fzf)
        [ -n "$branch" ] && git checkout "$branch"
      }

      # NixOS generation browser
      nixgen() {
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | \
          ${pkgs.fzf}/bin/fzf --tac
      }

      # Quick package search
      nix-search() {
        nix search nixpkgs "$@" | ${pkgs.fzf}/bin/fzf
      }

      # Public IP
      myip() {
        curl -s https://api.ipify.org
        echo ""
      }

      # System info
      sysinfo() {
        echo ""
        pfetch
        echo ""
        echo "=== Disk Usage ==="
        df -h / /home 2>/dev/null | grep -v tmpfs
        echo ""
        echo "=== Memory Usage ==="
        free -h
        echo ""
      }

      # Environment
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="less"
      export MANPAGER="bat"
      export LESS='-R --use-color -Dd+r$Du+b'

      # ZSH options
      setopt AUTO_CD
      setopt EXTENDED_GLOB
      setopt NOMATCH
      setopt NOTIFY
      setopt PROMPT_SUBST

      # Key bindings
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char

      # Welcome message
      if [ "$SHLVL" = 1 ]; then
        echo ""
        pfetch
        echo ""
      fi
    '';
  };

  # ============================================================================
  # BASH (backup shell)
  # ============================================================================
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      ll  = "eza -lah --icons";
      la  = "eza -A --icons";
      l   = "eza --icons";
      lt  = "eza --tree --level=2 --icons";
      gs  = "git status";
      ga  = "git add";
      gc  = "git commit";
      gp  = "git push";
      gl  = "git log --oneline --graph --decorate";
      gd  = "git diff";
      top = "btop";
      df  = "df -h";
      du  = "du -h";
      free = "free -h";
      fetch = "pfetch";
    };

    initExtra = ''
      export PS1='\[\e[2m\]󰭕\[\e[0;38;5;76m\]\u\[\e[32m\]@\[\e[38;5;31m\]\W\[\e[0m\] \$ '

      export PF_INFO="ascii title os host kernel uptime pkgs memory shell editor wm palette"
      export PF_ASCII="nixos"
      export PF_COL1=4
      export PF_COL2=6
      export PF_COL3=7
      export PF_ALIGN="9"
      export PF_SEP=":"

      btw() {
        clear
        echo ""
        pfetch
        echo ""
        echo "  \033[1;36m╭─────────────────────────────────╮\033[0m"
        echo "  \033[1;36m│\033[0m  \033[1;34m❄\033[0m  \033[1mI use NixOS btw\033[0m \033[1;34m😎\033[0m        \033[1;36m│\033[0m"
        echo "  \033[1;36m╰─────────────────────────────────╯\033[0m"
        echo ""
      }

      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)  tar xjf $1    ;;
            *.tar.gz)   tar xzf $1    ;;
            *.bz2)      bunzip2 $1    ;;
            *.rar)      unrar e $1    ;;
            *.gz)       gunzip $1     ;;
            *.tar)      tar xf $1     ;;
            *.tbz2)     tar xjf $1    ;;
            *.tgz)      tar xzf $1    ;;
            *.zip)      unzip $1      ;;
            *.Z)        uncompress $1 ;;
            *.7z)       7z x $1       ;;
            *)          echo "'$1' cannot be extracted" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s histappend

      if command -v fzf-share >/dev/null 2>&1; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi
    '';
  };

  # ============================================================================
  # GIT
  # ============================================================================
  programs.git = {
    enable = true;
    userName = "haschwalth";
    userEmail = "srivatsapoojary@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      diff.algorithm = "histogram";
      pager = {
        branch = false;
        tag = false;
      };
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
      };
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local   = "yellow";
          remote  = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old  = "red";
          new  = "green";
        };
        status = {
          added     = "green";
          changed   = "yellow";
          untracked = "cyan";
        };
      };
    };

    ignores = [
      "*~" "*.swp" "*.swo"
      ".DS_Store" ".idea" ".vscode"
      "*.log"
      "node_modules/"
      "__pycache__/" "*.pyc"
      ".env" ".direnv/"
    ];
  };

  # ============================================================================
  # BAT
  # ============================================================================
  programs.bat = {
    enable = true;
    config = {
      theme  = "Nord";
      style  = "numbers,changes,grid";
      paging = "auto";
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
      ];
    };
  };

  # ============================================================================
  # FZF
  # ============================================================================
  programs.fzf = {
    enable = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
  };

  # ============================================================================
  # ZOXIDE
  # ============================================================================
  programs.zoxide = {
    enable = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
  };

  # ============================================================================
  # TMUX
  # ============================================================================
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode  = "vi";
    customPaneNavigationAndResize = true;
    escapeTime   = 0;
    historyLimit = 10000;

    extraConfig = ''
      set -g mouse on
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      set -ga terminal-overrides ",xterm-256color:Tc"

      set -g status-style 'bg=#333333 fg=#5eacd3'
      set -g status-left-length 40
      set -g status-right '%Y-%m-%d %H:%M '

      set -g pane-border-style 'fg=#444444'
      set -g pane-active-border-style 'fg=#5eacd3'

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    '';
  };

  # ============================================================================
  # NEOVIM CONFIG SYMLINK
  # ============================================================================
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/haschwalth/dot_files/nvim";
}

