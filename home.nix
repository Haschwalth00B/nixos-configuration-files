{ config, pkgs, ... }:
{
  home.username = "haschwalth";
  home.homeDirectory = "/home/haschwalth";
  home.stateVersion = "24.05";
  
  # User packages - organized by category
  home.packages = with pkgs; [
    # Shell enhancements
    bat           # Better cat (manual use only)
    fzf           # Fuzzy finder
    eza           # Modern ls replacement
    ripgrep       # Better grep
    fd            # Better find
    zoxide        # Smart cd
    pfetch        # Minimalist system info
    
    # System utilities
    htop          # Process viewer
    btop          # Modern system monitor
    tree          # Directory tree viewer
    
    # Development tools
    tldr          # Simplified man pages
    jq            # JSON processor
  ];
  
  # ============================================================================
  # ZSH CONFIGURATION (PRIMARY SHELL)
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


    # History configuration
    history = {
      size = 10000;
      save = 20000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    

    shellAliases = {
      # ---- NixOS Management ----
      nrs = "sudo nixos-rebuild switch";

      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";
      nrsu = "sudo nixos-rebuild switch --upgrade";
      nrv = "sudo nixos-rebuild switch --show-trace";  # Verbose rebuild
      
      # ---- NixOS Configuration ----
      nixedit = "sudo $EDITOR /etc/nixos/configuration.nix";
      nixcd = "cd /etc/nixos";
      nixlist = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nixroll = "sudo nixos-rebuild switch --rollback";
      
      # ---- Nix Package Management ----
      nixsearch = "nix search nixpkgs";
      nixshell = "nix-shell -p";
      
      # ---- System Maintenance ----
      nixgc = "sudo nix-collect-garbage -d";
      nixopt = "sudo nix-store --optimise";
      nixclean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

      nixrepair = "sudo nix-store --verify --check-contents --repair";
      
      # ---- Enhanced ls commands (eza) ----
      ls = "eza --icons";
      ll = "eza -lah --icons --git";
      la = "eza -A --icons";
      l = "eza --icons";
      lt = "eza --tree --level=2 --icons";
      llt = "eza --tree --level=3 --icons --git -l";
      
      # ---- Git shortcuts ----
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";

      gpl = "git pull";
      gl = "git log --oneline --graph --decorate";
      gla = "git log --oneline --graph --decorate --all";
      gd = "git diff";
      gds = "git diff --staged";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      gba = "git branch -a";
      
      # ---- Better alternatives (manual usage) ----
      grep = "rg";
      find = "fd";
      top = "btop";
      cd = "z";  # Using zoxide
      
      # ---- Utility aliases ----
      df = "df -h";
      du = "du -h";
      free = "free -h";
      ps = "ps aux";
      
      # ---- Quick navigation ----
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # ---- Quick edits ----
      zshrc = "$EDITOR ~/.zshrc";
      vimrc = "$EDITOR ~/.config/nvim/init.lua";
      
      # ---- Fun ----
      fetch = "pfetch";
    };
    
    initExtra = ''
      # ---- Powerlevel10k theme ----
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # ---- Zoxide (smart cd) ----
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      
      # ---- FZF integration ----
      if command -v fzf-share >/dev/null 2>&1; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
      
      # FZF configuration
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}' 2>/dev/null"
      export FZF_DEFAULT_COMMAND="${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      
      # ---- Pfetch Configuration ----
      # Choose what to display
      export PF_INFO="ascii title os host kernel uptime pkgs memory shell editor wm palette"
      
      # ASCII art
      export PF_ASCII="nixos"
      
      # Color scheme - Nord style
      export PF_COL1=4   # Blue for labels
      export PF_COL2=6   # Cyan for info
      export PF_COL3=7   # White for separators
      
      # Alignment and separators
      export PF_ALIGN="9"
      export PF_SEP=":"
      
      # ---- BTW function - Pretty pfetch + message ----
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
      
      # ---- Enhanced functions ----
      
      # Create directory and cd into it
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # Extract any archive
      extract() {
        if [ -f "$1" ] ; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Quick file search
      ff() {
        ${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git . "''${1:-.}" | ${pkgs.fzf}/bin/fzf --preview 'bat --color=always {}' --preview-window=right:60%
      }
      
      # Quick directory search and cd
      fcd() {
        local dir
        dir=$(${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git . "''${1:-.}" | ${pkgs.fzf}/bin/fzf --preview 'eza --tree --level=1 --icons {}' --preview-window=right:60%)
        [ -n "$dir" ] && cd "$dir"
      }
      
      # Git fuzzy checkout
      fco() {
        local branch

        branch=$(git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | ${pkgs.fzf}/bin/fzf)
        [ -n "$branch" ] && git checkout "$branch"
      }

      
      # NixOS generation browser

      nixgen() {
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | ${pkgs.fzf}/bin/fzf --tac
      }
      
      # Quick package search with preview
      nix-search() {
        nix search nixpkgs "$@" | ${pkgs.fzf}/bin/fzf --preview 'nix eval nixpkgs#$(echo {} | cut -d" " -f1).meta.description 2>/dev/null || echo "No description available"'
      }
      
      # Get public IP
      myip() {
        curl -s https://api.ipify.org
        echo ""
      }
      
      # System info with pfetch
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

      
      # ---- Environment variables ----
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="less"
      export MANPAGER="bat"  # Use bat for man pages (better syntax highlighting)
      
      # Better less colors
      export LESS='-R --use-color -Dd+r$Du+b'
      
      # ---- ZSH options ----
      setopt AUTO_CD              # cd by just typing directory name
      setopt EXTENDED_GLOB        # Extended globbing
      setopt NOMATCH              # Print error if pattern has no matches
      setopt NOTIFY               # Report status of background jobs immediately
      setopt PROMPT_SUBST         # Enable parameter expansion in prompts
      
      # ---- Key bindings ----
      bindkey '^[[A' history-search-backward    # Up arrow
      bindkey '^[[B' history-search-forward     # Down arrow
      bindkey '^[[H' beginning-of-line          # Home key
      bindkey '^[[F' end-of-line                # End key
      bindkey '^[[3~' delete-char               # Delete key
      
      # ---- Welcome message (optional - comment out if you don't want it) ----
      if [ "$SHLVL" = 1 ]; then
        echo ""
        pfetch
        echo ""
      fi
    '';
  };
  
  # ============================================================================
  # BASH CONFIGURATION (BACKUP SHELL)
  # ============================================================================
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      # NixOS specific
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      
      # Enhanced ls commands
      ll = "eza -lah --icons";

      la = "eza -A --icons";
      l = "eza --icons";
      lt = "eza --tree --level=2 --icons";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
      gd = "git diff";
      
      # Better alternatives
      top = "btop";
      
      # Utility aliases
      df = "df -h";
      du = "du -h";
      free = "free -h";
      
      # Fun
      fetch = "pfetch";
    };
    
    initExtra = ''
      # Custom prompt
      export PS1='\[\e[2m\]󰭕\[\e[0;38;5;76m\]\u\[\e[32m\]@\[\e[38;5;31m\]\W\[\e[0m\] \\$ '
      
      # Pfetch configuration
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
      
      # Useful functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Better history
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s histappend
      
      # Enable fzf if available
      if command -v fzf-share >/dev/null 2>&1; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi
    '';
  };
  
  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
  programs.git = {
    enable = true;
    userName = "haschwalth";
    userEmail = "srivatsapoojary@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      
      # Better diff algorithm
      diff.algorithm = "histogram";
      
      # Use pager for branch and tag
      pager = {
        branch = false;
        tag = false;
      };
      
      # Useful aliases
      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";

        unstage = "reset HEAD --";
        last = "log -1 HEAD --stat";
        visual = "log --graph --oneline --decorate --all";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        contributors = "shortlog --summary --numbered";
        amend = "commit --amend --no-edit";
      };
      
      # Color configuration
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red";
          new = "green";
        };
        status = {
          added = "green";
          changed = "yellow";
          untracked = "cyan";
        };
      };
    };
    
    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      ".idea"
      ".vscode"
      "*.log"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".env"
      ".direnv/"
    ];
  };
  

  # ============================================================================
  # BAT CONFIGURATION (Better cat - manual use)
  # ============================================================================
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      style = "numbers,changes,grid";
      paging = "auto";
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
      ];
    };
  };
  
  # ============================================================================

  # FZF CONFIGURATION
  # ============================================================================
  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  
  # ============================================================================
  # ZOXIDE CONFIGURATION (Smart cd)
  # ============================================================================
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  
  # ============================================================================
  # TMUX CONFIGURATION
  # ============================================================================
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    historyLimit = 10000;
    
    extraConfig = ''
      # Enable mouse support
      set -g mouse on
      
      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
      
      # Renumber windows when one is closed
      set -g renumber-windows on
      
      # Enable true color support
      set -ga terminal-overrides ",xterm-256color:Tc"
      
      # Status bar configuration
      set -g status-style 'bg=#333333 fg=#5eacd3'
      set -g status-left-length 40
      set -g status-right '%Y-%m-%d %H:%M '
      
      # Pane border colors
      set -g pane-border-style 'fg=#444444'
      set -g pane-active-border-style 'fg=#5eacd3'
      
      # Better split bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Quick reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    '';

  };
  
  # ============================================================================
  # NEOVIM CONFIGURATION SYMLINK
  # ============================================================================
  home.file.".config/nvim".source = /home/haschwalth/dot_files/nvim;
}

