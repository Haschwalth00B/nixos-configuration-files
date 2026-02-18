{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs.nerd-fonts; [
      meslo-lg        # Recommended for Powerlevel10k (MesloLGS NF)
      fira-code       # Coding font with ligatures
      jetbrains-mono  # JetBrains coding font with ligatures
      hack            # Clean, readable monospace
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "MesloLGS NF" "FiraCode Nerd Font Mono" ];
        sansSerif = [ "DejaVu Sans" ];
        serif     = [ "DejaVu Serif" ];
      };
    };
  };
}
