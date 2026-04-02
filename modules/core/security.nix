{ config, pkgs, ... }:
{
	sops.age.keyFile = "/root/.config/sops/age/keys.txt";
	sops.defaultSopsFormat = "yaml";


	sops.secrets = {
		github_token = {
			sopsFile = ./../../secrets/github_token.yaml;
			owner = "root";
			mode = "0400";
		};
	

	};


	services.openssh = {
		enable = true;
		ports = [ 22 ];
	};
	networking.firewall.allowedTCPPorts = [ 22 ];
  

	environment.systemPackages = with pkgs; [
		sops
		age
  ];
}
