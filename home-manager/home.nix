# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or defin  e it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "marie";
    homeDirectory = "/home/marie"; };
    programs.zsh.autosuggestion.enable = true;
    programs.zsh.shellAliases = { backup = "restic -r rclone:onedrive:/backup/server backup --verbose /home";};
    programs.zsh.shellAliases = { update = "sudo nix flake update /home/marie/Dokumente/sexos";};
    programs.zsh.shellAliases = { rebuild = "sudo nixos-rebuild --flake /home/marie/Dokumente/sexos switch";};
    programs.zsh.oh-my-zsh.enable = true;
    programs.zsh.oh-my-zsh.theme = "crunch";
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [     
    htop
    gimp
    unzip
    thunderbird
    firefox
    vim
    davinci-resolve
    neofetch
    beeper
    qbittorrent
    openvpn3
    signal-desktop-beta
    zsh
    putty
    nmap
    hyfetch
    go
    nil
    lshw
    traceroute
    speedtest-cli
    element-desktop
    rustc
    filezilla
    pciutils
    docker
    git
    vscode
    libreoffice
    python3
    veracrypt
    metasploit
    ecryptfs
    gnumake
    discord
    wireshark-qt
    superTuxKart
    cargo
    gcc
    vlc
    alacritty
    mullvad
    prusa-slicer
    cmatrix
    btop
    wget
    restic
    chromium
    winetricks
    helvum
    lutris
    polychromatic
    rclone
    woeusb
    antimicrox
    pavucontrol
    setserial
    wineWowPackages.wayland
    tor-browser
    gnome-themes-extra
    catppuccin-gtk
    spotify
    betterdiscordctl
    openconnect
    freerdp
    killall
    gdown
    neovim
    gnomeExtensions.user-themes
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    python311Packages.pip
    gnome.gnome-tweaks
    vesktop
    brlaser
    pipes
    catppuccin-gtk
    catppuccin
    telegram-desktop
    picocom
    dnsmasq
    (catppuccin-gtk.override {
    accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
    tweaks = [ "rimless"]; # You can also specify multiple tweaks here
    variant = "mocha";
  })
    gnomeExtensions.burn-my-windows
    gnomeExtensions.desktop-cube
    gnomeExtensions.compiz-windows-effect
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.git.userName = "pilz0";
  programs.git.userEmail = "marie0@riseup.net";  

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}