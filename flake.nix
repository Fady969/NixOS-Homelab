{
	description = "NixOS Homelab";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";					# version

		sops-nix.url = "github:Mic92/sops-nix";
		sops-nix.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, sops-nix, ... }@inputs:
	let
		system = "x86_64-linux";																	# architecture
		host = "homelab";																					# host

		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
	};
	in {
 		nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
			inherit system pkgs;

			specialArgs = { inherit inputs host; };

			modules = [
				./hosts/${host}/default.nix
				./hosts/${host}/hardware-configuration.nix
				sops-nix.nixosModules.sops
			];
		};
	};
}
