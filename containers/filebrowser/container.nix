{ config, pkgs, ... }:

let
  dataDir = "/etc/nixos/containers/filebrowser/data";
in
{
	virtualisation.oci-containers = {
		backend = "podman";
		containers.filebrowser = {
			image = "docker.io/filebrowser/filebrowser:latest";

			ports = [ "8081:80" ];
			autoStart = true;

			volumes = [
				"${dataDir}:/srv"
				"${dataDir}/filebrowser.db:/database.db"
				"${dataDir}/settings.json:/config/settings.json"
			];

			extraOptions = [	
				"--name=filebrowser"
			];
		};
	};
}
