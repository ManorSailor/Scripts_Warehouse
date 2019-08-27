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
chc="Backup Restore List-all Remove Quit"
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
	mkdir -p "$dbpt"
	st_nm
	tar -czpf "$nm" $ipt 2>/dev/null
	mv "$nm" "$dbpt"
}

#Fix tar cannot create symlink error, cause android's storage filesystem format doesnt support moving/copying symlinks
fix_rest() {
	cd "$dbpt"
	cp "$flnm" "$HOME"
	cd "$HOME"
}

#Funtcion for Restoring.
tar_rest() {
	read -p "Enter File Name: " flnm
	fix_rest
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
		tar_bup
 		echo
 		echo -e "Configs Backed-Up at \n$dbpt"
		echo
 		;;

	"Restore")
		echo -e "\nRestoring Backup..."
		echo -e "\nHere is the list of all your Backups:"
		ls "$dbpt"
		echo
		tar_rest
		echo -e "\nConfigs Restored!"
		echo
            ;;
            
	"List-all")
		echo "Here is the list of all your Backups:"
		echo
		ls "$dbpt"
		echo
		;;

	"Remove")
		cd "$dbpt"
		echo -e "\nHere is the list of all your Backups:"
		ls "$dbpt"
		rm_file
		;;
            
	*) 
		echo invalid option
		echo
		;;
	esac
done