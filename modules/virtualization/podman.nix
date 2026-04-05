{ pkgs, ... }:

{
	virtualisation = {
		containers.enable = true;
		oci-containers.backend = "podman";
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
