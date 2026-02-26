{ pkgs, ... }:
{
  programs.tmux = {
    enable       = true;
    terminal     = "tmux-256color";   # better than screen-256color for italics
    keyMode      = "vi";
    prefix       = "C-a";            # more ergonomic than default C-b
    baseIndex    = 1;
    customPaneNavigationAndResize = true;
    escapeTime    = 0;
    historyLimit  = 50000;
    mouse         = true;

    # tmux-sensible provides sane defaults (UTF-8, focus events, etc.)
    plugins = with pkgs.tmuxPlugins; [
      sensible        # sane defaults
      vim-tmux-navigator  # seamless vim <-> tmux pane navigation (C-h/j/k/l)
      {
        plugin = resurrect;  # save & restore sessions across reboots
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;  # auto-save resurrect state every 15 min
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      {
        plugin = yank;  # copy to system clipboard with y in copy mode
        extraConfig = ''
          set -g @yank_action 'copy-pipe-no-clear'
        '';
      }
    ];

    extraConfig = ''
      # ── True colour ──────────────────────────────────────────────────────
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",tmux-256color:RGB"

      # ── Window & pane numbering ───────────────────────────────────────────
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      # ── Focus events (needed for vim autoread) ────────────────────────────
      set -g focus-events on

      # ── Splits (stay in current path) ────────────────────────────────────
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # ── Reload config ────────────────────────────────────────────────────
      bind r source-file ~/.config/tmux/tmux.conf \; display "✓ tmux reloaded"

      # ── Vi copy mode ─────────────────────────────────────────────────────
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      # ── Status bar ───────────────────────────────────────────────────────
      set -g status-position bottom
      set -g status-interval 5

      set -g status-style                'bg=#1e1e2e fg=#cdd6f4'
      set -g status-left-length          60
      set -g status-right-length         80

      set -g status-left  '#[bg=#89b4fa,fg=#1e1e2e,bold] 󰀄 #S #[bg=#1e1e2e,fg=#89b4fa]'
      set -g status-right '#[fg=#6c7086]  %H:%M #[fg=#45475a]│#[fg=#6c7086] %d %b #[fg=#45475a]│#[fg=#a6e3a1] #{continuum_status}'

      setw -g window-status-format         ' #I:#W '
      setw -g window-status-current-format '#[bg=#313244,fg=#89b4fa,bold] #I:#W '

      # ── Pane borders ─────────────────────────────────────────────────────
      set -g pane-border-style        'fg=#313244'
      set -g pane-active-border-style 'fg=#89b4fa'

      # ── Window title ─────────────────────────────────────────────────────
      set -g set-titles on
      set -g set-titles-string '#S — #W'

      # ── Misc ─────────────────────────────────────────────────────────────
      set -g display-time 2000
      set -g display-panes-time 2000
      set -wg mode-style 'bg=#313244 fg=#cdd6f4'
    '';
  };
}

