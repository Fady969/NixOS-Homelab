{
	imports = [
		../../modules/core/base.nix
		../../modules/core/network.nix
		../../modules/core/security.nix

		../../modules/services/adguard.nix
		../../modules/services/nginx.nix
		../../modules/services/monitoring.nix

		../../modules/virtualization/podman.nix

		../../containers/filebrowser/container.nix

	];

	networking = {
		hostName = "homelab";

		interfaces.eno1 = {
			ipv4.addresses = [
				{
					address = "192.168.178.50";
					prefixLength = 24;
				}
			];

			ipv6.addresses = [
				{
					address = "fd00::50";
					prefixLength = 64;
				}
			];
		};
	};	

	# Bootloader
	boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
		efi.efiSysMountPoint = "/boot/efi";
  };
}
