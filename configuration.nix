# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
  let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.haschwalth = import ./home.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nix-server"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = false;  # Easiest to use and most distros use this by default.


  networking.interfaces.enp2s0 = {
    ipv4.addresses = [
      {
        address = "192.168.1.34";  # Your desired static IP
        prefixLength = 24;
      }
    ];
    ipv4.routes = [
      {
        address = "0.0.0.0";
        prefixLength = 0;
        via = "192.168.1.1";        # Your gateway
      }
    ];
  };

  networking.resolvconf.enable = true;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,nixos.local";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  #turning off the display
  #boot.kernelParams = [ "video=eDP-1:d" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.haschwalth = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      neovim
      curl
      wget
    ];
  };

  programs.firefox.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    tailscale
    btop
    htop
    samba
    tmux
    pfetch-rs
    git
    go
    hugo
    powertop
    python3
    pciutils
    ripgrep
    gcc
    lshw
    #zsh
    #zsh-powerlevel10k
    #meslo-lgs-nf
    #zsh-powerlevel10k
    #zsh-autosuggestions
    #zsh-syntax-highlighting
  ];

  #users.defaultUserShell = pkgs.zsh;
  #programs.zsh = {
    #enable = true;
    #enableCompletion = true;
    #autosuggestions.enable = true;
    #syntaxHighlighting.enable = true;
    #ohMyZsh = {
      #enable = true;
      #plugins = [ "git" "z" ];
      #theme = "powerlevel10k/powerlevel10k";
    #};
  #};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "Wandenreich";
        "log file" = "/var/log/samba/log.%m";
        "max log size" = 50;
        "map to guest" = "Bad User";
      };

      homes = {
        comment = "Home Directories";
        browseable = "yes";
        writable = "yes";
      };
  };
};
  
  services.tailscale.enable = true;

  services.openssh.enable = true;

  #lidswitch
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  #powerManagement.enable = false;  # Disable NixOS power management if enabled
  powerManagement = {
    enable = true;
    powertop.enable = true;  # Enables powertop auto tune at startup
    cpuFreqGovernor = "schedutil";  # or other governors like performance or ondemand
  };

  #autoaspm
  systemd.services.autoaspm = {
    description = "Run autoaspm.py script at startup";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 /home/haschwalth/autoaspm/autoaspm.py";
      Restart = "on-failure";
      User = "root";  # or another user if preferred
    };
    enable = true;
  };




  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
  };
  
  #automatic updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  #automatic  cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 3d";
  nix.settings.auto-optimise-store = true;
  

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

