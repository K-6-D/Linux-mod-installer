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

#------------------------------Logos-------------------------------
logo_names+=("$mod_images_directory/logo.png") && logo_links+=('https://t4.ftcdn.net/jpg/01/21/22/57/360_F_121225745_6MScSAbSWYSWlRsPJonDPPDcp84BrdKo.jpg')
logo_names+=("$mod_images_directory/reset-logo.png") && logo_links+=('https://images.squarespace-cdn.com/content/54b55e28e4b04d469d0fc8eb/1504188257429-JM5TDS0REGART87DKJ8P/reset+button?format=1500w&content-type=image%2Fjpeg')
logo_names+=("$mod_images_directory/update-logo.png") && logo_links+=('https://www.stpaulschool.ca/wp-content/uploads/2021/01/New-Update.png')


function make_desktop_sortcuts() {
	counter=0

	for links in "${logo_links[@]}"; do
		wget -q -O "${logo_names[$counter]}" "$links"
		((counter++))
	done

	#------------------------------
	echo "[Desktop Entry]
	Name=Linux Mod Installer
	Exec=$mod_installer_script
	Icon=${logo_names[0]}
	Terminal=true
	Type=Application
	StartupNotify=true"\
	> "$HOME/Desktop/Deck-installer.desktop" &&\
	chmod +x "$HOME/Desktop/Deck-installer.desktop"
	#------------------------------
	
	#------------------------------
	echo "[Desktop Entry]
	Name=Linux Mod Installer Update
	Exec=$mod_installer_update_script
	Icon=${logo_names[2]}
	Terminal=true
	Type=Application
	StartupNotify=true"\
	> "$HOME/Desktop/Deck-installer-update.desktop" &&\
	chmod +x "$HOME/Desktop/Deck-installer-update.desktop"
	#------------------------------
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
readonly mod_images_directory="$mod_installer_directory/images"
#------------------------------------------------------------------
readonly mod_installer_script="$mod_installer_directory/run.sh"
readonly mod_installer_update_script="$mod_installer_directory/update.sh"
#------------------------------------------------------------------
readonly mod_installer_script_link='https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/mod-installer.sh'
readonly mod_installer_update_script_link='https://raw.githubusercontent.com/K-6-D/Linux-mod-installer/main/update.sh'
#------------------------------------------------------------------
create_directorys+=("$mod_installer_directory")
create_directorys+=("$mod_images_directory")
#------------------------------------------------------------------
if ping_wan "show"; then
    rm "$mod_installer_script" && curl -sSL "$mod_installer_script_link" | tr -d '\r' > "$mod_installer_script"
    rm "$mod_installer_update_script" && curl -sSL "$mod_installer_update_script_link" | tr -d '\r' > "$mod_installer_update_script"
    chmod +x "$mod_installer_script"
    chmod +x "$mod_installer_update_script"
    make_desktop_sortcuts
    echo -e "${GREEN}Updated${NOCOLOR}!."
else
    sleep 2
    exit
fi

echo -e "\033[32mPress enter to Continue..."
read -r
echo ""

bash "$mod_installer_script" && exit