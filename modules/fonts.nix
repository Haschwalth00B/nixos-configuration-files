{ pkgs, ... }:

{
  # ============================================================================
  # FONTS CONFIGURATION (NixOS 25.05+)
  # ============================================================================
  # Nerd Fonts for:
  # - eza icons (file/folder icons in terminal)
  # - Powerlevel10k theme (zsh prompt icons and symbols)
  # - General terminal use
  # ============================================================================

  fonts.packages = with pkgs.nerd-fonts; [

    meslo-lg           # Official recommended font for Powerlevel10k (MesloLGS NF)
    fira-code          # Great for coding with ligatures
    jetbrains-mono     # Excellent coding font from JetBrains
    hack               # Clean, readable monospace font
  ];

  # ============================================================================
  # FONT CONFIGURATION NOTES
  # ============================================================================
  # After rebuilding, configure your terminal emulator to use one of these fonts:
  #
  # For Powerlevel10k (recommended):
  #   Font: MesloLGS NF Regular
  #   Size: 10-12pt
  #
  # Common terminal emulator configs:
  #   - Kitty:         ~/.config/kitty/kitty.conf → font_family MesloLGS NF
  #   - Alacritty:     ~/.config/alacritty/alacritty.yml → family: "MesloLGS NF"
  #   - GNOME Term:    Preferences → Profile → Font → "MesloLGS NF Regular"
  #   - Konsole:       Settings → Edit Profile → Appearance → Font
  #
  # Alternative good choices:
  #   - FiraCode Nerd Font (with ligatures)
  #   - JetBrainsMono Nerd Font (with ligatures)
  #   - Hack Nerd Font (clean and simple)
  # ============================================================================
}

