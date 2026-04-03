{ config, pkgs, ... }:

let
  dataDir = "/var/lib/filebrowser";
	user = "filebrowser";
	uid = 999;
in
{
  #Create user and group
  users.users.${user} = {
    uid = uid;
    isSystemUser = true;
    group = user;
		linger = true;
    createHome = true;
    home = dataDir;
    description = "FileBrowser service user";
  };
  
  users.groups.${user} = {
    gid = uid;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 ${user} ${user} -"
  ];

 
	virtualisation.oci-containers = {
		containers.filebrowser = {
			podman.user = "${user}";
			image = "docker.io/filebrowser/filebrowser:latest";

			ports = [ "127.0.0.1:8081:8080" ];
			autoStart = true;
			podman.sdnotify = "container";					# remove when fix is merged https://github.com/NixOS/nixpkgs/pull/483309

			volumes = [
				"${dataDir}:/srv"
			];

			extraOptions = [	
				"--name=filebrowser"
			];
			environment = {
				"FB_PORT" = "8080";
				"FB_DATABASE" = "/data/filebrowser.db";
			};
		};
	};
	
	systemd.services."podman-filebrowser" = {
		serviceConfig = {
			Delegate = "yes";
		};
	};
}
