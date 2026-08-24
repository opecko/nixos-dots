{
  description = "ondra-pc system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };



  };

  outputs = { self, nixpkgs, noctalia, noctalia-greeter, claude-desktop, home-manager, ... }@inputs:
  {
    nixosConfigurations.ONDRA-PC = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	./noctalia.nix

	({ pkgs, ...}: {
          nixpkgs.overlays = [
	    claude-desktop.overlays.default 
          ];
	})

        home-manager.nixosModules.home-manager
	{
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.backupFileExtension = "backup";
	  home-manager.users.ondra = import ./home.nix;
	}


      ];
    };
  };
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

}
