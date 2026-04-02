{ config, pkgs, ... }:

{
	services.nginx = {
		enable = true;

		recommendedProxySettings = true;
		recommendedTlsSettings = true;
	

    
		virtualHosts = {
			"adguard.nix.home" = { 
				locations."/" = {
					proxyPass = "http://127.0.0.1:3003";
			};};
      
			"dash.nix.home" = {
				locations."/" = {
					proxyPass = "http://127.0.0.1:3001";
			};};

		};
	};
	networking.firewall.allowedTCPPorts = [ 80 443 ];
}
