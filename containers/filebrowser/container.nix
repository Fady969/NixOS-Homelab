{ config, pkgs, ... }:

let
  dataDir = "/var/lib/filebrowser";
	user = "filebrowser";
	uid = 1001;
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
		autoSubUidGidRange = true;
    description = "FileBrowser service user";
  };
  
  users.groups.${user} = {
    gid = uid;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0770 ${user} ${user} -"
		"d ${dataDir}/config 0770 ${user} ${user} -"
		"d ${dataDir}/srv 0770 ${user} ${user} -"
  ];

 
	virtualisation.oci-containers = {
		containers.filebrowser = {
			image = "docker.io/filebrowser/filebrowser:latest";

			ports = [ "127.0.0.1:8081:8080" ];
			autoStart = true;
			#podman.sdnotify = "container";					# remove when fix is merged https://github.com/NixOS/nixpkgs/pull/483309

			volumes = [
				"${dataDir}/srv:/srv"
				"${dataDir}/config:/config"
			];

			extraOptions = [	
				"--name=filebrowser"
				"--userns=keep-id"
			];
			environment = {
				"FB_PORT" = "8080";
				"FB_DATABASE" = "/config/filebrowser.db";
			};
		};
	};
	
}
