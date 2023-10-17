#!/bin/bash
#------------------------------------------------------------------
# Links to compatible Mods:
mod_name+=('OEM-Bike-Pack') mod_dir+=('/mods') mod_links+=("https://download2439.mediafire.com/t18oop8i0wdgYAONk43QuAPXo47QV735CVTf2VwriicPhzwjfpHqn_QWTRUgYVy7_5ZLMnEih2Y2v8OAyp3tvUxmH5m6df_NrQkr2mlMKsetaZaydeUd0bqB9XPbb3Fm9snQf8l7FQRIr8j04z4v3ZTl4JC1metk0owfAml4JmLq/o029owuf76gbqrs/MX+OEM+v0.18.2.zip")
mod_name+=('K6D-Profile') mod_dir+=('/profiles') mod_links+=("https://www.dropbox.com/scl/fi/px0x5skd1q0e3gyt8txie/K6D-Profile.zip?rlkey=79m1y45ilym5ujw4wv8ss32q6&dl=1")


#mod_name+=('Enduro-Loop')          mod_links+=('NULL')
#mod_name+=('Club-MX-compound')     mod_links+=('NULL')
#mod_name+=('Motofactory-Compound') mod_links+=('NULL')
#mod_name+=('Jurassic-Track')       mod_links+=('NULL')
#mod_name+=('Supermoto-OEM') 	    mod_links+=('NULL')
#mod_name+=('Enduro-Bike-Pack')     mod_links+=('NULL')
#------------------------------------------------------------------
readonly game_number=0
readonly game_name='MX-Bikes'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NOCOLOR='\033[0m'
readonly mod_installer_version=0.2
steam_directorys+=("$HOME/.local/share/Steam/steamapps")
steam_directorys+=("$HOME/.steam/steam/steamapps")

for i in "${steam_directorys[@]}"; do
	if [[ -d "$i" ]]; then
		steam_directory="$i"
		break
	fi
done

readonly mod_installer_directory="$steam_directory/mod_installer"
readonly mods_backup_directory="$mod_installer_directory/backups"
readonly download_directory="$mod_installer_directory/downloaded-mods"
readonly mod_installer_config="$mod_installer_directory/config.conf"
readonly mods_list_directory="$mod_installer_directory/installed-mods"
#-------------------------Game-Directories-------------------------
game_directory+=("$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes")
#------------------------------------------------------------------
create_directorys+=("$mod_installer_directory")
create_directorys+=("$mods_backup_directory")
create_directorys+=("$download_directory")
create_directorys+=("$mods_list_directory")
#------------------------------------------------------------------

function kill_processes() {
	echo -e "\033[32mPress enter to exit..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    kill -- -$$ 2>/dev/null || true
}
function basic() {
	trap kill_subprocesses SIGINT
	mod_count="${#mod_name[@]}"
}
function create_directorys() {
	for i in "${create_directorys[@]}"; do
		if [[ ! -d "$i" ]]; then
			if mkdir "$i"; then
	    		echo -e "${GREEN}Directory Created${NOCOLOR}"
	            #chmod 755 "$i" #sudo
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
function create_config_files() {
	if [[ ! -e "$mod_installer_config" ]]; then
	    touch "$mod_installer_config"
	    echo "--------------MOD-INSTALLER--------------" | tee "$mod_installer_config" >/dev/null
	    sed -i '$a'"-----------------------------------------" "$mod_installer_config"
	    sed -i '$a'"Steam-Deck-Mod-Installer-Version: $mod_installer_version" "$mod_installer_config"
	fi

	if [[ ! -e "$mods_list_directory/$game_name.list" ]]; then
	    touch "$mods_list_directory/$game_name.list"
	    echo "-----------------MOD-LIST-----------------" | tee "$mods_list_directory/$game_name.list" >/dev/null
	    sed -i '$a'"MOD_NAME: Downloaded,Active" "$mods_list_directory/$game_name.list"
	    sed -i '$a'"------------------------------------------" "$mods_list_directory/$game_name.list"
	
	fi
}
function ping_wan() {
    if wget --spider --quiet "https://www.cloudflare.com/" &>/dev/null; then
        [[ "$1" != "silent" ]] && echo -e "${GREEN}Internet is up${NOCOLOR}"
        return 0
    else
        [[ "$1" != "silent" ]] && echo -e "[${RED}Internet is down${NOCOLOR}]"
        return 1
    fi
}
function pull_update() {
	data_local="$(grep -n "${mod_name[$1]}" "$mods_list_directory/$game_name.list")"
	
	if [[ $data_local == "" ]]; then
		sed -i '$a'"${mod_name[$1]}:,false,false" "$mods_list_directory/$game_name.list"
		data_local="$(grep -n "${mod_name[$1]}" "$mods_list_directory/$game_name.list")"
	fi
	
	if [[ -e "$download_directory/${mod_name[$1]}.zip" && $(echo "$data_local" | cut -f2 -d ',') == "true" ]]; then
		downloaded=true
	else
		downloaded=false
	fi

	active="$(echo "$data_local" | cut -f3 -d ',')"
	push_update "$1"
}
function push_update() {
	sed -i "s/${mod_name[$1]}:.*/${mod_name[$1]}:,$downloaded,$active/" "$mods_list_directory/$game_name.list"
}
function backup_mods() {
	if [[ ! -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
		echo -e "${RED}Backing up game data${NOCOLOR}! This can take some time..."
		sleep 1
		zip -r "$mods_backup_directory/$game_name-backup.zip" "${game_directory[$game_number]}" >/dev/null\
		&& echo -e "${GREEN}Backup finished${NOCOLOR}!."
		sleep 1
	fi
}
function download_mods() {
	counter=0
	
	for link in "${mod_links[@]}"; do
		pull_update $counter
		remaining=$(( mod_count - counter -1))
	
	    if [[ $downloaded == "false" ]]; then
			if ! ping_wan "silent"; then
				echo -e "[${RED}Internet is down${NOCOLOR}]"
				kill_processes
			fi

		    if wget -q --show-progress --no-check-certificate -O "$download_directory/""${mod_name[$counter]}.zip" "$link"; then
	    		echo -e "${GREEN}Downloded ${RED}'${mod_name[$counter]}'${NOCOLOR} [$remaining] ${GREEN}Remaining${NOCOLOR}."
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

	echo ""
}
function install_mods() {
	counter=0
	
	for link in "${mod_links[@]}"; do
		pull_update $counter
		remaining=$(( mod_count - counter -1))
	
	    if [[ $active == "false" && $downloaded == "true" ]]; then
			if unzip -o "$download_directory/""${mod_name[$counter]}.zip" -d "${game_directory[$game_number]}${mod_dir[$counter]}" &>/dev/null; then
				echo -e "${GREEN}installed '${RED}${mod_name[$counter]}${GREEN}' Successfully${NOCOLOR} [$remaining] ${GREEN}Remaining${NOCOLOR}."
				active=true
				push_update $counter
			else
				echo -e "${RED}Failed to install mod!${NOCOLOR}"
				sleep 2
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

echo -e "\033[32mPress enter to exit..."
read -r

exit

# bash <(wget -qO- https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh)
