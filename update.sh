#!/bin/bash
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NOCOLOR='\033[0m'

function kill_processes() {
	echo -e "\033[32mPress enter to exit..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    kill -- -$$ 2>/dev/null || true
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

function create_directorys() {
	for i in "${create_directorys[@]}"; do
		if [[ ! -d "$i" ]]; then
			if mkdir "$i"; then
	    		echo -e "${GREEN}Directory Created${NOCOLOR}"
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

steam_directorys+=("$HOME/.local/share/Steam/steamapps")
steam_directorys+=("$HOME/.steam/steam/steamapps")

for i in "${steam_directorys[@]}"; do
	if [[ -d "$i" ]]; then
		steam_directory="$i"
		break
	fi
done
#------------------------------------------------------------------
readonly mod_installer_directory="$steam_directory/mod_installer"
#------------------------------------------------------------------
readonly mod_installer_script="$mod_installer_directory/run.sh"
readonly mod_installer_update_script="$mod_installer_directory/update.sh"
#------------------------------------------------------------------
readonly mod_installer_script_link='https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/mod-installer.sh'
readonly mod_installer_update_script_link='https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh'
#------------------------------------------------------------------
create_directorys+=("$mod_installer_directory")
#------------------------------------------------------------------
if ping_wan "show"; then
	curl -sSL "$mod_installer_script_link" | tr -d '\r' > "$mod_installer_script"
    curl -sSL "$mod_installer_update_script_link" | tr -d '\r' > "$mod_installer_update_script"
    chmod +x "$mod_installer_script"
    chmod +x "$mod_installer_update_script"

    echo -e "${GREEN}Updated${NOCOLOR}!."
else
    sleep 2
    exit
fi

echo -e "\033[32mPress enter to Continue..."
read -r

bash "$mod_installer_script" && exit