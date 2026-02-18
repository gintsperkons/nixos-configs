{ inputs,
  outputs, 
  ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./boot.nix
    ./networking.nix
    ./security.nix
    ./packages.nix
    ./desktop-common.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    config = {
        allowUnfree = true;
    };
  };
}
