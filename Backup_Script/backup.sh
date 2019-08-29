#! /bin/bash
#Script for backing-up and reinstalling configs, .rc files.
#Its pain in the @$$ to configure your configs, rc, aliases etc files after reinstalling Termux.
#A Barebone script which will be improved in the near future.
#Written by Sars!
#0.6

#GLOBAL VARIABLES
#Import the config file containing backup path.
source ~/.Backup_Utility/.config

#Path from where the files needs to be backed up.
ipt=../usr/etc/

#Choices
chc="Backup Restore List-all Custom-path Remove Quit"
PS3="Choose: "

#######################################
#Wrapper/Helper functions STARTS.
#######################################
ls() {
	command ls -lh "$1" 2>/dev/null
}

rm() {
	command rm -r "$1" "$2" 2>/dev/null
}

mkdir() {
	command mkdir "$1" "$2" 2>/dev/null
}

mv() {
	command mv "$1" "$2" 2>/dev/null
}
######################################
#Wrapper/Helper functions ENDS.
######################################

#Show the menu
#Allow the functions to be called defined below. Hackish way, thanks stackoverflow :P
show_menu() {
	select opt in ${chc[@]}; do
	echo $opt
	break
	done
}

#Check if Directory exists.
chk_dir() {
	if [[ -d "$1" ]];
		then
			echo -e "\nDirectory Exists!"
			show_menu

	elif [[ ! -d "$1" ]];
		then
			mkdir "$1"
			echo -e "\nDirectory Created!!"
			return 0

	else
			echo -e "\nUnknown Input $1"
			exit
	fi
}

#Function to set user defined custom backup paths.
cst_bpt() {
	echo
	read -p "Enter new Default Backup Path (Absolute): " cbpt
	chk_dir "$cbpt"

	while true; do
		sed -i "s%cbpt=%cbpt=~/$cbpt%" .Backup_Utility/.config #Big thanks to this user, https://serverfault.com/a/857495
		echo -e "\nDefault Backup-Path is now: $cbpt"
	break
	done
}

#Read the config file & call functions accordingly.
read_cfg() {
	if [[ -z "$cbpt" && "$1" == 'Backup' ]];
 		then
        	tar_bup "$dbpt"

	elif [[ -z "$cbpt" && "$1" == 'Restore' ]];
    	then
        	tar_rest "$dbpt"

	elif [[ -n "$cbpt" && "$1" == 'Backup' ]];
    	then
        	tar_bup "$cbpt"

 	elif [[ -n "$cbpt" && "$1" == 'Restore' ]];
    	then
        	tar_rest "$cbpt"

    elif [[ -z "$cbpt" && "$1" == 'List-all' ]];
    	then
    		ls "$dbpt"

    elif [[ -n "$cbpt" && "$1" == 'List-all' ]];
    	then
    		ls "$cbpt"

    elif [[ -z "$cbpt" && "$1" == 'Remove' ]];
    	then
    		rm_file "$dbpt"

    elif [[ -n "$cbpt" && "$1" == 'Remove' ]];
    	then
    		rm_file "$cbpt"
    fi
}

#Check if file exists.
chk_file() {
 	if [[ -f "$1" ]];
 	    then
 	        return 0
 	        
	elif [[ -z "$1" ]];
		then
			echo -e "\nPlease Enter Filename!"
			exit

 	else
  	        echo -e "\n$flnm File not found!"
            exit
	fi
}

#Function for removing Backup files.
rm_file() {
	cd "$1"
	echo "$1"
	echo -e "\nHere is the list of all your Backups:"
	ls "$1"
	echo
	
	read -p "Enter Filename: " flnm
	chk_file "$flnm"
	echo
	read -p "Are you sure you want to remove $flnm?: " ans

	if [[ "$ans" == "Yes" || "$ans" == "Y" || "$ans" == "y" || "$ans" == "yes" ]];
		then
			rm "$flnm"
			echo -e "\nRemoved!"
			return 0

	elif [[ -z "$ans" ]];
		then
			echo -e "\nEmpty string! Aborting..."
			exit

	else
		echo -e "\nAborting.."
		exit
	fi		
}

#Fucntion to set backup file name.
st_nm() {
	read -p "Enter the Name for backup file: " nm

	if [[ -n "$nm" ]];
		then
			echo -e "\nName has been set!"
	else
			echo -e "\nUsing default name for backup file"
			nm="etc"
	fi
}

#Function for Backing-Up.
tar_bup() {
	mkdir -p "$1"
	st_nm
	tar -czpf "$nm" $ipt 2>/dev/null
	mv "$nm" "$1"
	echo -e "Configs Backed-Up at \n$1"
}

#Fix tar cannot create symlink error, cause android's storage filesystem format doesnt support moving/copying symlinks
fix_rest() {
	cd "$1"
	cp "$2" "$HOME" 2>/dev/null
	cd "$HOME"
}

#Funtcion for Restoring.
tar_rest() {
	echo -e "\nHere is the list of all your Backups:"
	ls "$1"
	echo
	read -p "Enter File Name: " flnm
	fix_rest "$1" "$flnm"
	chk_file "$flnm"
	tar -xzpf "$flnm" -C ../ 2>/dev/null
	rm "$flnm"
}

#Iterate over the menu everytime
while true; do
COLUMNS=5
opt=$(show_menu)

case $opt in
	"Quit")
		break
		;;

	"Backup")
		echo -e "\nCreating Backup....."
		read_cfg 'Backup'
 		echo
 		;;

	"Restore")
		echo -e "\nRestoring Backup..."
		read_cfg 'Restore'
		echo -e "\nConfigs Restored!"
		echo
        ;;
            
	"List-all")
		echo "Here is the list of all your Backups:"
		echo
		read_cfg 'List-all'
		echo
		;;

	"Remove")
		read_cfg 'Remove'
		echo
		;;

	"Custom-path")
		cst_bpt
		echo
		;;
            
	*) 
		echo invalid option
		echo
		;;
	esac
done