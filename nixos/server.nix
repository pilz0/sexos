# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
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
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # FIXME: Add the rest of your current configuration

  #Set your hostname
  networking.hostName = "framwok";
  programs.zsh.enable = true;
  services.mullvad-vpn.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 1337 ];
  virtualisation.docker.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #X11 Server
  services.xserver.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
    console.keyMap = "de";
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
    i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  time.timeZone = "Europe/Berlin";
  # Configure keymap in X11
  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "de";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  users.defaultUserShell = pkgs.zsh;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    marie = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "ichmagschwänze";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" ];
    };
  };
  programs.steam.enable = true;
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    pkgs.gnome-console
    gnome-contacts
    gnome-logs
    gnome-maps
    pkgs.gnome-tour
    simple-scan
    yelp
    geary
  ];
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
      banner = "
      ***************************************************************************
                                  NOTICE TO USERS
      This is a Federal computer system and is the property of the United
      States Government. It is for authorized use only. Users (authorized or
      unauthorized) have no explicit or implicit expectation of privacy.
      Any or all uses of this system and all files on this system may be
      intercepted, monitored, recorded, copied, audited, inspected, and disclosed to
      authorized site, Department of Energy, and law enforcement personnel,
      as well as authorized officials of other agencies, both domestic and foreign.
      By using this system, the user consents to such interception, monitoring,
      recording, copying, auditing, inspection, and disclosure at the discretion of
      authorized site or Department of Energy personnel.
      Unauthorized or improper use of this system may result in administrative
      disciplinary action and civil and criminal penalties. By continuing to use
      this system you indicate your awareness of and consent to these terms and
      conditions of use. LOG OFF IMMEDIATELY if you do not agree to the conditions
      stated in this warning.
      *****************************************************************************";
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      marie = import ../home-manager/home.nix;
    };
  };
  
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE="1";
    };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
