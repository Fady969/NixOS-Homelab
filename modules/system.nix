{ config, pkgs, inputs, ... }: 
{
	imports = [
		./core/base.nix
		./core/network.nix
		./core/security.nix

		./services/adguard.nix
		./services/nginx.nix
		./services/monitoring.nix

		./virtualization/podman.nix
	

		#./../containers/filebrowser/container.nix
		#./../vms/.../vm.nix
	];
}
