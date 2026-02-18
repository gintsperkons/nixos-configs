{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";


    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    zen-browser,
    systems,
    ...
    } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system: 
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

  in {
    inherit lib;

    inputs.nixpkgs.config.allowUnfree = true;
    inputs.nixpkgs-stable.config.allowUnfree = true;




    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      #Main desktop
      #hippo = lib.nixosSystem {
      #  modules = [./hosts/hippo];
      #  specialArgs = {
      #    inherit inputs outputs zen-browser;
      #  }
      #}

      #Laptop 
      ferret = lib.nixosSystem {
        modules = [
          ./hosts/ferret
          inputs.sops-nix.nixosModules.sops
          ];
        specialArgs = {
          inherit inputs outputs zen-browser;
        };
      };

   

    };
  };
}
