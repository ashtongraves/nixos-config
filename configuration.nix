{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  zramSwap.enable = true;

  home-manager.users.ashton = { pkgs, ... }: {
    home.stateVersion = "24.05";
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
    };
  };

  networking.hostName = "bandos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  #services.getty.autoLoginUser = "ashton";
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  environment.sessionVariables = rec {
    NIXOS_OZONE_WL = "1";
  };

  environment.homeBinInPath = true;

  services.dbus = { 
    enable = true;
    packages = with pkgs; [ pass-secret-service ];
  };

  services.jack = { 
    jackd.enable = true;
    alsa.enable = true;
    #loopback.enable = true;
  };

  security.polkit.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  #users.users.ashton.packages = with pkgs; [
  #  (google-chrome.override {
  #    commandLineArgs = [
  #      "--enable-features=UseOzonePlatform"
  #      "--ozone-platform=wayland"
  #    ];
  #  })
  #];

  users.users.ashton = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      google-chrome
      (google-chrome.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
        ];
      })	
      bitwarden
      vlc
      appimage-run
      steam
      kitty
      calibre
      jq
      wallust
      pqiv
      slurp
      grim
      sox
      oh-my-zsh
      spotify
      vscode
      htop
      nvtopPackages.full
      discord
      hyprpicker
      hyprpaper
      hypridle
      hyprlock
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "ashton" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    neovim
    pamixer
    #blueman
    wget
    pass-secret-service
    git
    gnupg
    pass
    tree
    zsh
    dmenu-wayland
    rofi-wayland
    vesktop # for audio screensharing for discord
    dunst # for notifications
    networkmanagerapplet
    waybar
    hyprpaper
    pass-secret-service
    killall
    wl-clipboard
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    pavucontrol # Pulseaudio mixer. Can be used with pipewire. Using to get waybar pulseaudio module working
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      font-awesome 
    ];
    enableDefaultPackages = false;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Ashton Graves";
        email = "mail@ashtongraves.com";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set clipboard=unnamedplus
        set number
        set shiftwidth=2 smarttab
        set expandtab
      '';
    };
  };
 
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  programs.zsh = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.passSecretService.enable = true;
  services.flatpak.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [];

  system.copySystemConfiguration = true;



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
  system.stateVersion = "24.05"; # Did you read the comment?
}

