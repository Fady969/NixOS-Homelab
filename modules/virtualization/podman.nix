{ pkgs, ... }:

{
	virtualisation = {
		containers.enable = true;
		podman = {
			enable = true;
			dockerCompat = true;
			defaultNetwork.settings.dns_enabled = false;
		};
	};

	environment.systemPackages = with pkgs; [
		podman-compose
		buildah
		skopeo
	];

}
