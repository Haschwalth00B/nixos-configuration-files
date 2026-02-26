{ config, pkgs, ... }:

# ── Shared aliases used in both ZSH and Bash ─────────────────────────────────
let
  commonAliases = {
    # ── NixOS management ────────────────────────────────────────────────────
    nrs    = "sudo nixos-rebuild switch";
    nrt    = "sudo nixos-rebuild test";
    nrb    = "sudo nixos-rebuild boot";
    nrsu   = "sudo nixos-rebuild switch --upgrade";
    nrv    = "sudo nixos-rebuild switch --show-trace";
    # nom (nix-output-monitor) variants — prettier build output
    nrsnom = "sudo nixos-rebuild switch |& nom";
    nrtnom = "sudo nixos-rebuild test   |& nom";

    # ── NixOS config navigation ──────────────────────────────────────────────
    nixedit  = "sudo $EDITOR /etc/nixos/configuration.nix";
    nixcd    = "cd /etc/nixos";
    nixlist  = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    nixroll  = "sudo nixos-rebuild switch --rollback";
    nixclean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";


    # ── Nix package management ───────────────────────────────────────────────
    nixsearch = "nix search nixpkgs";
    nixshell  = "nix-shell -p";
    nixrun    = "nix run nixpkgs#";    # quick: nixrun cowsay hello

    # ── ls (eza) ─────────────────────────────────────────────────────────────
    ls  = "eza --icons";
    ll  = "eza -lah --icons --git";
    la  = "eza -A --icons";
    l   = "eza --icons";
    lt  = "eza --tree --level=2 --icons";
    llt = "eza --tree --level=3 --icons --git -l";

    # ── Git ───────────────────────────────────────────────────────────────────
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
    lg  = "lazygit";

    # ── Modern replacements ───────────────────────────────────────────────────
    grep = "rg";
    find = "fd";
    top  = "btop";
    cd   = "z";
    cat  = "bat --paging=never";
    df   = "duf";                # modern df — colourful, grouped
    du   = "du -h";
    free = "free -h";
    ps   = "ps aux";

    # ── Utility ───────────────────────────────────────────────────────────────
    ".."   = "cd ..";
    "..."  = "cd ../..";
    "...." = "cd ../../..";
    fetch  = "pfetch";
    ports  = "ss -tulnp";               # show listening ports
    psg    = "ps aux | rg";             # fuzzy process grep
    myip   = "curl -s https://api.ipify.org && echo";
    localip = "ip -br addr";

    # ── Config quick-edits ────────────────────────────────────────────────────
    zshrc = "$EDITOR ~/.zshrc";
    vimrc = "$EDITOR ~/.config/nvim/init.lua";

    # ── Docker shortcuts ──────────────────────────────────────────────────────
    dk  = "docker";
    dkc = "docker compose";
    dkps = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";

    ld  = "lazydocker";
  };

  # ── Shared shell functions (written once, used in ZSH) ───────────────────
  shellFunctions = ''
    # Create dir and cd into it
    mkcd() { mkdir -p "$1" && cd "$1" }

    # Extract any archive
    extract() {
      if [ -f "$1" ]; then
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

    # Fuzzy file open
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

    # Git fuzzy branch checkout
    fco() {
      local branch
      branch=$(git branch --all | grep -v HEAD | sed "s/.* //" | \
        sed "s#remotes/[^/]*/##" | sort -u | ${pkgs.fzf}/bin/fzf)
      [ -n "$branch" ] && git checkout "$branch"
    }

    # NixOS generation browser (fuzzy)
    nixgen() {
      sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | \
        ${pkgs.fzf}/bin/fzf --tac
    }


    # Fuzzy nix package search
    nix-search() {
      nix search nixpkgs "$@" | ${pkgs.fzf}/bin/fzf
    }

    # Show listening ports in a readable table
    listening() {
      if [ -z "$1" ]; then
        sudo ss -tulnp
      else

        sudo ss -tulnp | rg "$1"
      fi
    }

    # Quick HTTP server in current directory
    serve() {
      local port="''${1:-8000}"
      echo "Serving on http://0.0.0.0:$port"
      ${pkgs.python3}/bin/python3 -m http.server "$port"
    }

    # System info dashboard

    sysinfo() {
      echo ""
      pfetch
      echo ""
      echo "  === Disk ==="
      duf
      echo ""
      echo "  === Memory ==="
      free -h
      echo ""
      echo "  === Top processes ==="
      ps aux --sort=-%cpu | head -8
      echo ""
    }

    # Colourful btw banner
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

    # Enter a running docker container with fzf selection
    dsh() {
      local ctr
      ctr=$(docker ps --format '{{.Names}}' | ${pkgs.fzf}/bin/fzf --prompt="Container: ")
      [ -n "$ctr" ] && docker exec -it "$ctr" sh
    }

    # Git: show a pretty diff of the last N commits (default 1)
    gdl() {
      git diff HEAD~"''${1:-1}" HEAD
    }

    # Backup a file with a timestamp
    bak() {
      cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
    }
  '';


in
{
  # ============================================================================
  # ZSH
  # ============================================================================
  programs.zsh = {
    enable            = true;
    dotDir	      = "/home/haschwalth";
    enableCompletion  = true;

    history = {
      size       = 50000;
      save       = 100000;
      path       = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share      = true;
      extended   = true;   # save timestamps in history
    };

    shellAliases = commonAliases;

    initContent = ''
      # ── Powerlevel10k ────────────────────────────────────────────────────
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # ── Zoxide ───────────────────────────────────────────────────────────
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      # ── FZF options ──────────────────────────────────────────────────────
      export FZF_DEFAULT_OPTS="
        --height 40%

        --layout=reverse
        --border
        --info=inline
        --preview-window=right:60%:wrap
        --bind='ctrl-/:toggle-preview'
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
      "
      export FZF_DEFAULT_COMMAND="${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git"
      # FZF preview for CTRL-T
      export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:100 {}'"

      # ── Pfetch config ────────────────────────────────────────────────────
      export PF_INFO="ascii title os host kernel uptime pkgs memory shell editor palette"
      export PF_ASCII="nixos"
      export PF_COL1=4
      export PF_COL2=6
      export PF_COL3=7
      export PF_ALIGN="9"
      export PF_SEP=":"

      # ── Environment ──────────────────────────────────────────────────────
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="less"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # bat-rendered man pages
      export LESS='-R --use-color -Dd+r$Du+b'
      export GOPATH="$HOME/go"
      export PATH="$PATH:$GOPATH/bin:$HOME/.cargo/bin"


      # ── ZSH options ───────────────────────────────────────────────────────
      setopt AUTO_CD
      setopt EXTENDED_GLOB

      setopt NOMATCH
      setopt NOTIFY
      setopt PROMPT_SUBST
      setopt HIST_VERIFY          # show command before executing from history
      setopt CORRECT              # suggest corrections for typos
      setopt COMPLETE_ALIASES

      # ── Key bindings ──────────────────────────────────────────────────────
      bindkey '^[[A'  history-search-backward
      bindkey '^[[B'  history-search-forward
      bindkey '^[[H'  beginning-of-line

      bindkey '^[[F'  end-of-line
      bindkey '^[[3~' delete-char
      bindkey '^[[1;5C' forward-word    # Ctrl+Right
      bindkey '^[[1;5D' backward-word   # Ctrl+Left

      # ── Functions ─────────────────────────────────────────────────────────
      ${shellFunctions}

      # ── direnv hook ───────────────────────────────────────────────────────
      # (system-level direnv sets up the hook, but be explicit for PATH reasons)

      command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

      # ── Welcome message (first shell level only) ──────────────────────────
      if [[ "$SHLVL" == 1 ]]; then
        echo ""
        pfetch
        echo ""
      fi
    '';
  };

  # ============================================================================
  # BASH (fallback shell — keeps essentials)
  # ============================================================================
  programs.bash = {
    enable            = true;
    enableCompletion  = true;
    shellAliases      = commonAliases;

    initExtra = ''
      export PS1='\[\e[2m\]󰭕\[\e[0;38;5;76m\]\u\[\e[32m\]@\[\e[38;5;31m\]\W\[\e[0m\] \$ '

      export EDITOR="nvim"
      export VISUAL="nvim"
      export GOPATH="$HOME/go"
      export PATH="$PATH:$GOPATH/bin:$HOME/.cargo/bin"

      export PF_INFO="ascii title os host kernel uptime pkgs memory shell editor palette"
      export PF_ASCII="nixos"

      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      shopt -s histappend

      # Functions (subset for bash)
      mkcd() { mkdir -p "$1" && cd "$1"; }
      serve() {
        local port="''${1:-8000}"
        echo "Serving on http://0.0.0.0:$port"
        python3 -m http.server "$port"
      }
      listening() {
        if [ -z "$1" ]; then sudo ss -tulnp; else sudo ss -tulnp | grep "$1"; fi
      }

      if command -v fzf-share >/dev/null 2>&1; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi

      command -v direnv &>/dev/null && eval "$(direnv hook bash)"
      command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
    '';
  };
}

