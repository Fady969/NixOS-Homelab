{ config, pkgs, ... }:

{
	time.timeZone = "Europe/Berlin";

	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "de_DE.UTF-8";
		LC_IDENTIFICATION = "de_DE.UTF-8";
		LC_MEASUREMENT = "de_DE.UTF-8";
		LC_MONETARY = "de_DE.UTF-8";
		LC_NAME = "de_DE.UTF-8";
		LC_NUMERIC = "de_DE.UTF-8";
		LC_PAPER = "de_DE.UTF-8";
		LC_TELEPHONE = "de_DE.UTF-8";
		LC_TIME = "de_DE.UTF-8";
	};

	console.keyMap = "de";

	users.users.fady = {
		isNormalUser = true;
		description = "Fatdrit";
		extraGroups = [ "networkmanager" "wheel" ];
	};


	programs = {
		bash.shellAliases = {
			l = "ls -alh";
			ll = "ls -l";
			ls = "ls --color=tty";
			lt = "";

			rebuild = "/etc/nixos/scripts/rebuild.sh";
		};

		git = {
			enable = true;
			config = {
				user.name = "Fady969";
				user.email = "Fatdrit.Shala@pm.me";
				init.defaultBranch = "main";
			};
		};

	};


  
	environment.variables = { EDITOR = "vim"; };
	environment.systemPackages = with pkgs; [
		((vim-full.override {  }).customize{
			name = "vim";
			vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
				start = [ vim-nix vim-lastplace ];
				opt = [];
			};
			vimrcConfig.customRC = ''
				set nocompatible
				set backspace=indent,eol,start
				syntax on

				autocmd Filetype nix setlocal tabstop=2
				autocmd Filetype nix setlocal shiftwidth=0

				'';
			}
		)
		wget
		tmux
		git
		tree
		fastfetch
	];



	system.stateVersion = "22.05";
}
