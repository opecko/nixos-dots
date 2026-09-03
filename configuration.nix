# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix # DO NOT DELETE!!!!!!!!!!!!!!!
      ./nvidia.nix
      ./fonts.nix
      ./appimage.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "systemd.tpm2_wait=0"
  ];

  boot.kernelModules = [ "sr_mod" ];


  networking.hostName = "ONDRA-PC"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ondra" = {
    isNormalUser = true;
    description = "Ondra";
    extraGroups = [ "networkmanager" "wheel" "uinput" "dialout" ];

    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    xdg-user-dirs
    gvfs
    samba
    cifs-utils
    wget
    neovim
    satty
    git
    btop
    fastfetch
    kitty
    bat
    eza
    fish
    vesktop
    bibata-cursors
    nwg-displays
    nwg-look
    adw-gtk3
    papirus-icon-theme
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kdePackages.breeze
    prismlauncher
    rmpc
    mpc
    mpd
    mpd-discord-rpc
    mpd-mpris
    cava
    claude-code
    claude-desktop
    platformio
    opencode
    gcc 
    tree-sitter
    appimage-run
    mpv
    python315
    ffmpeg
    mullvad-vpn
    vscode.fhs
    dbeaver-bin
    prusa-slicer
    kdePackages.kdenlive
    kdePackages.kio-extras
    kdePackages.kcalc
    bitwarden-desktop
  ];

  programs.hyprland.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  programs.gpu-screen-recorder.enable = true;
  programs.zsh.enable = true;
  programs.kdeconnect.enable = true;
  programs.lazygit.enable = true;
 
  programs.obs-studio.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;


  programs.dconf.enable = true;
  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];


  services.flatpak.enable = true;
  services.tailscale.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;  # potřeba pro Wayland, na Xorg vynech
    openFirewall = true;
  };



  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  services.openssh.enable = true;
  services.gvfs.enable = true;
  services.dbus.enable = true;

  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };

  services.mpd = {
    enable = false;
    user = "ondra";
  
  
    settings = {
      port = 6600;

      music_directory = "/home/ondra/Music";

      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Sound Server";
        }
  
        {
          type = "fifo";
          name = "Visualizer feed";
          path = "/tmp/mpd.fifo";
          format = "44100:16:2";
        }
      ];
  
      auto_update = true;
      replaygain = "auto";
    };
  };
  
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };


  systemd.user.services.mpd-mpris = {
    description = "MPD MPRIS bridge";
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
      Restart = "on-failure";
    };
  };

  systemd.user.services.mpd-discord-rpc = {
    description = "MPD Discord Rich Presence";

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-sesison.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.mpd-discord-rpc}/bin/mpd-discord-rpc";
      Restart = "on-failure";
    };
  };

  systemd.services.systemd-tpm2-setup.enable = false;
  systemd.services.systemd-tpm2-setup-early.enable = false;
  systemd.targets."tpm2".enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
