#!/bin/bash
#--------------------------Supported Games-------------------------
# Link to compatible Mods: 
mod_name+=('Enduro-Loop')          mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594269&authkey=!AIx4MSRq2UgNSXE')
mod_name+=('Club-MX-compound')     mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594270&authkey=!AGPfYKrjPHzU54A')
mod_name+=('Motofactory-Compound') mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594271&authkey=!ALgoI1CAMhNuJsU')
mod_name+=('Jurassic-Track')       mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594272&authkey=!AGHIv67pvAMply0')
mod_name+=('Supermoto-OEM') 	   mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594273&authkey=!AL_W8qVTXu3173w')
mod_name+=('Enduro-Bike-Pack')     mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594274&authkey=!ADMFRKJW3nYTDH8')
mod_name+=('OEM-Bike-Pack')        mod_links+=('https://onedrive.live.com/download?resid=2A9F45089CF290C9%21594275&authkey=!ABTZvP1CnPpi7Bg')
#------------------------------------------------------------------
readonly game_number=0
readonly game_name='MX-Bikes'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NOCOLOR='\033[0m'
readonly mod_installer_version=0.2
readonly steam_directory="$HOME/.local/share/Steam/steamapps"
readonly mod_installer_directory="$steam_directory/mod_installer"
readonly mod_installer_script="$mod_installer_directory/run.sh"
readonly mods_backup_directory="$mod_installer_directory/backups"
readonly download_directory="$mod_installer_directory/downloaded-mods"
readonly mod_installer_config="$mod_installer_directory/config.conf"
readonly mods_list_directory="$mod_installer_directory/installed-mods"
#-------------------------Game-Directories-------------------------
game_directory+=("$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes/mods")
#------------------------------------------------------------------
create_directorys+=("$mod_installer_directory")
create_directorys+=("$mods_backup_directory")
create_directorys+=("$download_directory")
create_directorys+=("$mods_list_directory")
#------------------------------------------------------------------
kill_processes() {
    kill -- -$$
    sudo echo -e "${RED}killed...${NOCOLOR}"
    sleep 1
}
basic() {
	trap kill_subprocesses SIGINT
}
backup_script() {
	if [[ "$PWD/$0" != "$mod_installer_script" ]]; then
		cp "$PWD/$0" "$mod_installer_script"
	fi
}
create_directorys() {
	for i in "${create_directorys[@]}"; do
		if [[ ! -d "$i" ]]; then
			if mkdir "$i"; then
	    		echo -e "${GREEN}Directory Created${NOCOLOR}"
	            sudo chmod 755 "$i"
	            sudo chmod 2755 "$i"
			else
				echo -e "${RED}Failed to create Directory!${NOCOLOR}"
				kill_processes
			fi
	    else
	    	echo -e "${GREEN}Directory Already Created${NOCOLOR}"
	    fi
	done

	backup_script
}
create_config_files() {
	if [[ ! -e "$mod_installer_config" ]]; then
	    touch "$mod_installer_config"
	    echo "--------------MOD-INSTALLER--------------" | sudo tee "$mod_installer_config" >/dev/null
	    sed -i '$a'"-----------------------------------------" "$mod_installer_config"
	    sed -i '$a'"mod-installer-version: $mod_installer_version" "$mod_installer_config"
	fi

	if [[ ! -e "$mods_list_directory/$game_name.list" ]]; then
	    touch "$mods_list_directory/$game_name.list"
	    echo "-----------------MOD-LIST-----------------" | sudo tee "$mods_list_directory/$game_name.list" >/dev/null
	    sed -i '$a'"MOD_NAME: Downloaded,Active" "$mod_installer_config/$game_name.list"
	    sed -i '$a'"------------------------------------------" "$mods_list_directory/$game_name.list"
	
	fi
}
ping_wan() {
    if wget --spider --quiet "https://www.cloudflare.com/" >/dev/null; then
		echo -e "${GREEN}internet is up${NOCOLOR}"
    else
        echo -e "${RED}Internet is down${NOCOLOR}"
		kill_processes
    fi
}
pull_update() {
	mod_name_local="${mod_name[$1]}"
	data_local="$(grep -n "$mod_name_local" "$mods_list_directory/$game_name.list")"
	
	if [[ $data_local == "" ]]; then
		sed -i '$a'"$mod_name_local:,false,false" "$mods_list_directory/$game_name.list"
		data_local="$(grep -n "$mod_name_local" "$mods_list_directory/$game_name.list")"
	fi
	
	if [[ -e "$download_directory/$mod_name_local.zip" ]]; then
		downloaded=true
	else
		downloaded=false
	fi

	active="$(echo "$data_local" | cut -f3 -d ',')"
	push_update "$1"
}
push_update() {
	mod_name_local="${mod_name[$1]}"
	sed -i "s/$mod_name_local:.*/$mod_name_local:,$downloaded,$active/" "$mods_list_directory/$game_name.list"
}
backup_mods() {
	if [[ ! -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
		echo -e "${RED}Backing up game data${NOCOLOR}! This can take some time.!"
		zip -r "$mods_backup_directory/$game_name-backup.zip" "${game_directory[$game_number]}" >/dev/null
	fi
}
download_mods() {
	counter=0
	
	for link in "${mod_links[@]}"; do
		pull_update $counter
	
	    if [[ $downloaded == "false" ]]; then
			ping_wan
	
		    if wget -O "$download_directory/""${mod_name[$counter]}.zip" "$link"; then
	    		echo -e "${GREEN}Download ${RED}'${mod_name[$counter]}'${NOCOLOR}"
	    		downloaded=true
				push_update $counter
			else
				echo -e "${RED}Failed to download mod!${NOCOLOR}"
				kill_processes
			fi
		else
			echo -e "${RED}'${mod_name[$counter]}' ${GREEN}Is already downloaded${NOCOLOR}!."
		fi
			((counter++))
	done
}
install_mods() {
	counter=0
	
	for link in "${mod_links[@]}"; do
		pull_update $counter
	
	    if [[ $active == "false" && $downloaded == "true" ]]; then
			if unzip -o "$download_directory/""${mod_name[$counter]}.zip" -d "${game_directory[$game_number]}"; then
				echo -e "${GREEN}installed '${RED}${mod_name[$counter]}${GREEN}' Successfully${NOCOLOR}"
				active=true
				push_update $counter
			else
				echo -e "${RED}Failed to install mod!${NOCOLOR}"
				kill_processes
			fi
		elif [[ $active == "true" ]]; then
			echo -e "${RED}'${mod_name[$counter]}' ${GREEN}Is already Installed${NOCOLOR}!."
	    fi
		((counter++))
	done
}

basic #1

create_directorys #2

create_config_files #3

backup_mods #4

download_mods #5

install_mods #6

curl -sSL "link" | bash
