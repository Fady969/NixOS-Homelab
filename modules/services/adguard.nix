{ config, pkgs, ... }:

{
	services.adguardhome = {
		enable = true;
		mutableSettings = false;

		host = "0.0.0.0";
		port = 3003; # Web UI
   

		settings = {
			dns = {
				bind_hosts = [ "0.0.0.0" "::" ];
				port = 53;	# dns port
	
				ratelimit = 0;
			
				cache_ttl_min = 600;
	
				upstream_dns = [
					"9.9.9.9"
					"149.112.112.112"
				];
	
				bootstrap_dns = [
	  			"9.9.9.9"
	  			"149.112.112.112"
	  			"1.1.1.1"
				];
			};
      
			filtering = {
				protection_enabled = true;
				filtering_enabled = true;

				blocked_response_ttl = 3600;
	
				rewrites = [		# local dns entries
					{ domain = "nix.home"; answer = "192.168.178.50"; enabled = true; }
					{ domain = "*.nix.home"; answer = "192.168.178.50"; enabled = true; }

				];
			};
      

			filters = map(url: { enabled = true; url = url; }) [
				"https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
				"https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
				"https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"  # Steven Black's List
				"https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt" # Hegazi Pro
				"https://big.oisd.nl"	# osid big
			];
		};
	};


	networking.firewall.allowedTCPPorts = [ 53 3003 ];
	networking.firewall.allowedUDPPorts = [ 53 ];
}
