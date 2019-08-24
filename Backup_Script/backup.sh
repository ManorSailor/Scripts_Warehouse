#! /bin/bash
#Script for backing-up and reinstalling configs, .rc files.
#Its pain in the @$$ to configure your configs, rc, aliases etc files after reinstalling Termux.
#A Barebone script which will be improved in the near future.
#Written by Sars!
#0.3

#GLOBAL VARIABLES
#Import the config file containing backup path.
source ~/.Backup_Utility/.config

#Path from where the files needs to be backed up.
ipt=../usr/etc/

#Choices
chc="Backup Restore List-All Quit"
PS3="Choose: "

#######################################
#Wrapper/Helper functions STARTS.
#######################################
ls() {
	command ls -lh "$1"
}

rm() {
	command rm -r "$1" "$2"
}

mkdir() {
	command mkdir "$1" "$2" 2>/dev/null
}

mv() {
	command mv "$1" "$2"
}
######################################
#Wrapper/Helper functions ENDS.
######################################

#Fucntion to set backup file name.
st_nm() {
	read -p "Enter the Name for backup file: " nm

	if [[ -n "$nm" ]];
		then
			echo -e "\nName has been set!"
			nm="$nm".tar.gz

	else
			echo -e "\nUsing default name for backup file"
			nm="etc.tar.gz"
	fi
}

#Read the backup file name.
rd_nm() {
	echo -e "\nHere is the list of Backups: "
	ls "$dbpt"
	echo

	cd "$dbpt"
	read -p "Enter name of the file to Restore: " nme

	if [[ -n "$nme" ]];
		then
			echo -e "\nRestoring..."
			nme="$nme".tar.gz

	else 
			echo -e "\nNo file exists with the name: $nme"
			exit
	fi		
}

#Function for Backing-Up.
tar_bup() {
	mkdir -p "$dbpt"
	st_nm
	tar -czpf "$nm" $ipt 2>/dev/null
	mv "$nm" "$dbpt"
}

#Funtcion for Restoring.
tar_rest() {
	rd_nm
	tar -xzpf "$nme" -C ../ 2>/dev/null
}

#Display the menu
#COLUMNS=0
select opt in $chc
do
	if [ $opt == 'Quit' ]
		then
			break

	elif [ $opt == 'Backup' ]
		then
			echo -e "\nCreating Backup....."
			tar_bup
			echo
			echo -e "Configs Backed-Up at \n$dbpt"

	elif [ $opt == 'Restore' ]
		then
			echo -e "\nRestoring Backup..."		
			tar_rest
			echo -e "\nConfigs Restored!"

	elif [ $opt == 'List-All' ]
		then
			echo "Here is the list of all your Backups:"
			echo
			ls "$dbpt"
			echo
	fi
done