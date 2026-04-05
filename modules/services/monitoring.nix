{ config, pkgs, ... }:

{
	# Secrets
	sops.secrets.grafana_env = {
		sopsFile = ./../../secrets/grafana.yaml;
		owner = "grafana";
		group = "grafana";
		mode = "0400";
	};


	# moving dashboards
	environment.etc."grafana-dashboards".source = ./grafana-dash;


	# Node Exporter
	services.prometheus.exporters.node = {
		enable = true;
		port = 9100;

		enabledCollectors = [
			"systemd"
			"cpu"
			"diskstats"
			"filesystem"
			"loadavg"
			"meminfo"
			"netdev"
		];
	};

	# Prometheus
	services.prometheus = {
		enable = true;


		port = 9090;

		scrapeConfigs = [
			{
				job_name = "node";

				static_configs = [
					{
						targets = [ "127.0.0.1:9100" ];
					}
				];
			}
		];
	};

	# Grafana
	services.grafana = {
		enable = true;

		settings = {
			server = {	http_addr = "0.0.0.0"; http_port = 3001; };

			security = {
				admin_user = "admin";
				disable_gravatar = true;
				# cookie_secure = true;
			};
			
			users = { 
				allow_sign_up = false;
      };
    };

		provision = {
			enable = true;

			datasources.settings.datasources = [
				{	
					name = "Prometheus";
					type = "prometheus";
					url = "http://127.0.0.1:9090";
					access = "proxy";
					isDefault = true;
        }
      ];

			dashboards.settings.providers = [
				{ name = "default"; options.path = "/etc/grafana-dashboards"; }
	    
			];
		};

#		plugins = [
#      
#		];

	};
 
	# admin password
	systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.secrets.grafana_env.path;
  

	# Firewall
	networking.firewall.allowedTCPPorts = [
		3001  # Grafana
		9090  # Prometheus
		9100  # Node Exporter
	];
}
