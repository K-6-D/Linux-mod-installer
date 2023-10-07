#!/bin/bash
#--------------------------Supported Games-------------------------
# MX-Bikes-0, to-do-1, to-do-2, to-do-3, to-do-4, to-do-5, to-do-6
#------------------------------------------------------------------
game_number=0 # Game numbers are above.
load_default=true # 
#------------------------------------------------------------------
# Link to compatible Mods: https://shorturl.at/mHJY9
mod_name+=('Enduro-Loop-Main') && mod_links+=('https://public.sn.files.1drv.com/y4msWpHCaMV9M1OIrb44nY9d-a-GINezkRSPrlPA5cyn4Rn10h5TKEhsh1HSniBahVAOQuaJzT0QtPDryfw4QZWUDcSnudNQKjHoct8Q4S-Gb0tTIk7n2rYTtLiNGzyiO9b6Qty7exZkVM-Tj9JbaB2K6q5YfeaKn2_LEu52pW6hjLGtrWYLGn8V8HV8X7ehjU6GcRlEF19RibI0rYLZZsL5_rRCXxt01_-jCVw7zghbKY?AVOverride=1')
mod_name+=('Club-MX') && mod_links+=('https://public.sn.files.1drv.com/y4m5HcBsX9CacIi0txyp3-y940NJt-TDNlR2izDFJXkFn7aA9_8IfyMRdXbQ5YKvI7fhuW1Qb0CwCZEiGUKyo3E92iyst8Mf--zPnO34n-jiykKNUmSGiZxeEkHj67yhuQA3uv8F_K1oW2dEijK7pcjuDDUE8YxWGIjlgGXE9SH_sV021DGyYEA2RDXzbB2dbs-C0loWb8lz_m0GPF9B1zD_iAsPcQJXJXMHMVdCOOzpPQ?AVOverride=1')

#------------------------------------------------------------------
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
#game_directory+=("$steam_directory/compatdata/000000/pfx/drive_c/users/steamuser/Documents/")
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
	if [[ "$PWD/$0" != "$mod_installer_script" ]]; then
		cp "$PWD/$0" "$mod_installer_script"
	fi
	
	if [[ $game_number == "0" ]]; then
		game_name='MX-Bikes'
	elif [[ $game_number == "1" ]]; then
		game_name='LOL-Bikes'
	else
		echo -e "${RED}Game is not Supported!${NOCOLOR}"
		kill_processes
	fi

	trap kill_subprocesses SIGINT
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
	    
		sleep .2
	done

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