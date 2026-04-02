{ config, pkgs, inputs, ... }: 
{
	imports = [
		./core/base.nix
		./core/network.nix
		./core/security.nix

		./services/adguard.nix
		./services/nginx.nix
		./services/monitoring.nix

		# ./virtuilization/podman.nix
	

		#./../containers/.../container.nix
		#./../vms/.../vm.nix
	];
}
