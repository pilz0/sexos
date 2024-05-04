{
  description = "sexos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # TODO: Add any other flake you might need
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix, 
    ...
  } @ inputs: let
    inherit (self) outputs;
    pkgs = import nixpkgs { system = "x84_64-linux"; };
  in {
     homeConfigurations."marie" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit spicetify-nix;};
        modules = [
            ./home.nix
            ./spicetify.nix # file where you configure spicetify
        ];
     };
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      framwok = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };
  };
#    outputs = {
#    self,
#    nixpkgs,
#    home-manager,
#    ...
#  } @ inputs: let
#    inherit (self) outputs;
#  in {
    # NixOS configuration entrypoint
#    # Available through 'nixos-rebuild --flake .#your-hostname'
#    nixosConfigurations = {
#      # FIXME replace with your hostname
#      serva = nixpkgs.lib.nixosSystem {
#        specialArgs = {inherit inputs outputs;};
#        # > Our main nixos configuration file <
#        modules = [./nixos/server.nix];
#      };
#    };
#  };
}
