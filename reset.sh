#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

game_number=0
steam_directory=""
mod_installer_directory=""

function get_game_number() {
    case "${game_number}" in
        0)
            game_name='MX-Bikes'
            ;;
        1)
            game_name='MX-Bikes'
            ;;
        *)
            echo "game not found"
            ;;
    esac
}
function kill_processes() {
	echo -e "\033[32mPress enter to exit..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    kill -- -$$ 2>/dev/null || true
}
function find_steam_directory() {
    steam_directorys=("$HOME/.local/share/Steam/steamapps" "$HOME/.steam/steam/steamapps")

    for i in "${steam_directorys[@]}"; do
    	if [[ -d "$i" ]]; then
    		steam_directory="$i"
    		break
    	fi
    done

    mod_installer_directory="$steam_directory/mod_installer"
    download_directory="$mod_installer_directory/downloaded-mods"
    mods_backup_directory="$mod_installer_directory/backups"
}
function pull_update() {
	data_local="$(grep -n "${mod_name[$1]}" "$mods_list_directory/$game_name.list")"
	
	if [[ $data_local == "" ]]; then
		sed -i '$a'"${mod_name[$1]}:,false,false,bad," "$mods_list_directory/$game_name.list"
		data_local="$(grep -n "${mod_name[$1]}" "$mods_list_directory/$game_name.list")"
	fi
	
	if [[ -e "$download_directory/${mod_name[$1]}.zip" && $(echo "$data_local" | cut -f2 -d ',') == "true" ]]; then
		downloaded=true
	else
		downloaded=false
	fi

	active="$(echo "$data_local" | cut -f3 -d ',')"
	checksum="$(echo "$data_local" | cut -f4 -d ',')"
	push_update "$1"
}
function push_update() {
	sed -i "s/${mod_name[$1]}:.*/${mod_name[$1]}:,$downloaded,$active,$checksum,/" "$mods_list_directory/$game_name.list"
}
function load_backup() {
    pull_update ""
    game_directorys=(
	    "$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes"
    )

	if [[ -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
        rm -r "${game_directorys[$game_number]}/mods"
        unzip -o "$mods_backup_directory/$game_name-backup.zip" -d "${game_directorys[$game_number]}" >/dev/null\
		&& echo -e "${GREEN}Reset finished${NOCOLOR}!."
		sleep 1
    else
        echo -e "${RED}No Game Backup Found${NOCOLOR}!!."
        kill_processes
	fi
}

get_game_number
find_steam_directory
load_backup
kill_processes