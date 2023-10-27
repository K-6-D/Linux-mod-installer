#!/bin/bash
# Links to compatible Mods: Must be in the correct order.
#
mod_name=(
	'Jurassic-Track'
	'Supermoto-OEM'
	'Motofactory-Compound'
	'Club-MX-compound'
	'Enduro-Loop'
	'Enduro-Bike-Pack'
	'OEM-Bike-Pack'
#	'K6D-Profile'
) 
mod_dir=(
	'/mods'
	'/mods'
	'/mods'
	'/mods'
	'/mods'
	'/mods'
	'/mods'
#	'/profiles'
) 
mod_links=(
	"https://lhm81q.sn.files.1drv.com/y4mVyHZI78T_Lu_dmlhrpRjYcd7VEsVhlF7k_F0wo-3OZ2GtJIDTtIa3lixLm-bk_4SsKSIM0EA4_2XpRFVcm_gLbK9RJJ3tI_GMlHmoUH3CqWis3MB64hGk3vHwLlGbyMY7q2FXntDLa9oQuhBcMA685dYcv0lj6U69RuSJFHWg0LC7SIfdxI2bukSvfdTQZaH/Verified-G0-V1-Jurassic-Track.zip?download&psid=1"
	"https://pf6umg.sn.files.1drv.com/y4moyuukdlG_vSsmz2kGS4I_DVma2BxPca9umxAlmrke76M4y5TERA5VZecFx35suxKRPFbIm0B7BKycbVxLv51THgazCqurG3BafMT13Z1nAlqU1_JJrH-kgnJA2QvKbljkJhaPDz0cEkIsbe53ElNDtLHx4N1PO2gdZzorxUlTdc7vqez-5UHFNCjfFVh8EPv/Verified-G0-V1-SMOEM-v0.15.1.zip?download&psid=1"
	"https://lpjjdw.sn.files.1drv.com/y4mSQ8JczP-7yoJr_hDW3ZotPkRxjlmcEsk-W935-vD8psEv3sgACmZegc_N8bv4VzK_lPHfvyD4ssI9uCym7-KQHCFmDDOdbzlNqoQ2EibJtgIjP330gDTuc8O9UJX0BIJYzWdCS-DulMc_O4PH288FnQya_Dx17CkMXLAfe3_ynUan4vxpE8d7Rp4XYHMjxdr/Verified-G0-V1-Motofactory-Compound.zip?download&psid=1"
	"https://ylylgg.sn.files.1drv.com/y4mCW4ZKCMyGP_xmf0iRCdHDggNlX6sX8RWW2Bo3WPeWKOqC_ah8ktSXCtXYAOnY6loxh7oQN6Iz6vXjxOE0LOlBMNPXGQOM5H_YqSUQSGEWyAHrAIZyCoCJBTN6Zsc9YdS4IOzvB1q6QEQkA_yJgjOT0S0Ygl06OUCe2HSluYsPurfy_CJLzAGF69L68X8upd4/Verified-G0-V1-Club-MX.zip?download&psid=1"
	"https://v0opyg.sn.files.1drv.com/y4myAmct8BvddK3R8JxrcMrqdfP3Gwhpya75yZE1bLdxlpdShJ4fRta2oC-wwIcTTsNglaJnEar0EcG_4aKtjrV8iFzImeQrkL_DT_NTb7-ee3qWxGJG6nbkxxNXBBrVkT2wd-wFO4InYTKS0c_KmwR7Ac_pj6gH7YKs4Z9qV8CYX_onUSxFqLnpkpOKYD6HMx_/Verified-G0-V1-EnduroLoop-Main.zip?download&psid=1"
	"https://xortjw.sn.files.1drv.com/y4mWzd45vopRDYI6m8dv1fn02wOCuV_jiDAJXORjyTMLqBpPFkOMPGsGFheOiN0uMCBAJsrrgM9z-k2aLUtaEu4PPI60a_bVGevsG52Fot8NRApflTjmt0nNlh6X9sAPrA2iEiUY9ncqVz_mn0hhQDFNqnhLiI_TJnIeT9x_abn_X5hSc6kOEZMV4WcrN8skDPW/Verified-G0-V1-Enduro-Bike-Pack-v0.15.4.zip?download&psid=1"
	"https://download2439.mediafire.com/t18oop8i0wdgYAONk43QuAPXo47QV735CVTf2VwriicPhzwjfpHqn_QWTRUgYVy7_5ZLMnEih2Y2v8OAyp3tvUxmH5m6df_NrQkr2mlMKsetaZaydeUd0bqB9XPbb3Fm9snQf8l7FQRIr8j04z4v3ZTl4JC1metk0owfAml4JmLq/o029owuf76gbqrs/MX+OEM+v0.18.2.zip"
#	"https://www.dropbox.com/scl/fi/px0x5skd1q0e3gyt8txie/K6D-Profile.zip?rlkey=79m1y45ilym5ujw4wv8ss32q6&dl=1"
)

readonly game_number=0
readonly game_name='MX-Bikes'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NOCOLOR='\033[0m'
readonly mod_installer_version=0.2
steam_directorys=(
	"$HOME/.local/share/Steam/steamapps"
	"$HOME/.steam/steam/steamapps"
)

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
game_directorys=(
	"$steam_directory/compatdata/655500/pfx/drive_c/users/steamuser/Documents/PiBoSo/MX Bikes"
)
#------------------------------------------------------------------
create_directorys=(
	"$mod_installer_directory"
	"$mods_backup_directory"
	"$download_directory"
	"$mods_list_directory"
)
#------------------------------------------------------------------

function kill_processes() {
	echo -e "${GREEN}Press enter to exit${NOCOLOR}..."
	read -r
    echo -e "${RED}killed...${NOCOLOR}"
    sleep .1
    exit
}
function basic() {
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

	echo ""
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
	    sed -i '$a'"MOD_NAME: Downloaded,Active,Checksum," "$mods_list_directory/$game_name.list"
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
	data_local="$(grep -n "${mod_name[$1]}:" "$mods_list_directory/$game_name.list")"
	
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
function backup_mods() {
	if [[ ! -e "$mods_backup_directory/$game_name-backup.zip" ]]; then
		echo -e "${RED}Backing up game data${NOCOLOR}! This can take some time..."
		pushd "${game_directorys[$game_number]}" || return >/dev/null
		zip -r "$mods_backup_directory/$game_name-backup.zip" "mods/" >/dev/null\
		&& sleep 1 && echo -e "${GREEN}Backup finished${NOCOLOR}!."
		popd || return
		sleep .5
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
			
			echo -e "${GREEN}Downloading ${NOCOLOR}'${RED}${mod_name[$counter]}${NOCOLOR}'"

		    if wget -q --show-progress --no-check-certificate -O "$download_directory/""${mod_name[$counter]}.zip" "$link"; then
	    		echo -e "${GREEN}Downloded ${RED}'${mod_name[$counter]}'${NOCOLOR} [$remaining] ${GREEN}Remaining${NOCOLOR}."
	    		downloaded=true
				push_update $counter
			else
				echo -e "${RED}Failed to download mod!${NOCOLOR}"
				kill_processes
			fi
		else
			echo -e "${NOCOLOR}'${RED}${mod_name[$counter]}${NOCOLOR}' ${GREEN}Is already downloaded${NOCOLOR}!."
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
			echo -e "${GREEN}installing ${NOCOLOR}'${RED}${mod_name[$counter]}${NOCOLOR}'"
			if output=$(unzip -o "$download_directory/""${mod_name[$counter]}.zip" -d "${game_directorys[$game_number]}${mod_dir[$counter]}" 2>&1); then #&>/dev/null
				echo -e "${GREEN}installed '${RED}${mod_name[$counter]}${GREEN}' Successfully${NOCOLOR} [$remaining] ${GREEN}Remaining${NOCOLOR}."
				active=true
				checksum="good"
				push_update $counter
			elif [[ $(echo "$output" | grep -oP "bad CRC") == "bad CRC" ]]; then
				echo "Encountered a checksum error  during unzip operation."
				echo -e "${GREEN}installed '${RED}${mod_name[$counter]}${GREEN}' With a checksum error.${NOCOLOR} [$remaining] ${GREEN}Remaining${NOCOLOR}."
				active=true
				checksum="bad"
				push_update $counter
			else
				echo -e "${RED}Failed to install mod!${NOCOLOR}"
				sleep 2
				kill_processes
			fi
		elif [[ $active == "true" ]]; then
			echo -e "${NOCOLOR}'${RED}${mod_name[$counter]}${NOCOLOR}' ${GREEN}Is already Installed${NOCOLOR}!."
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
kill_processes #7
