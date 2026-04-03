{ config, pkgs, ... }:

let
  dataDir = "/etc/nixos/containers/filebrowser/data";
in
{
	virtualisation.oci-containers = {
		backend = "podman";
		containers.filebrowser = {
			image = "docker.io/filebrowser/filebrowser:latest";

			ports = [ "8081:8080" ];
			autoStart = true;

			volumes = [
				"${dataDir}:/srv"
			];

			extraOptions = [	
				"--name=filebrowser"
			];
			environment = {
				"FB_PORT" = "8080";
			};
		};
	};
}
