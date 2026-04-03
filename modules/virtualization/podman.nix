{ pkgs, ... }:

{
	virtualisation = {
		containers.enable = true;
		podman = {
			enable = true;
			dockerCompat = true;
			defaultNetwork.settings = {
				dns_servers = [ "127.0.0.1" ];
			};
		};
	};

	environment.systemPackages = with pkgs; [
		podman-compose
		buildah
		skopeo
	];

}
