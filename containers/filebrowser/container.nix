{ config, pkgs, ... }:

let
  dataDir = "/var/lib/filebrowser";
	user = "filebrowser";
	uid = "999";
in
{
  #Create user and group
  users.users.${user} = {
    uid = 999;
    isSystemUser = true;
    group = "filebrowser";
    createHome = false;
    home = "/var/lib/filebrowser";
    description = "FileBrowser service user";
  };
  
  users.groups.${user} = {
    gid = 999;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 ${user} ${user} -"
  ];

 
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
				"--user=${toString uid}:${toString uid}"
			];
			environment = {
				"FB_PORT" = "8080";
			};
		};
	};
}
