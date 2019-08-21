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

#Move the archive to TermuxBackups
ball=~/etc.tar.gz

#Choices
chc="Backup Restore List-All Quit"
PS3="Choose: "

#######################################
#Wrapper functions.
#######################################
ls() {
	command ls -lh $1
}

dl() {
	rm -r
}

mkdir() {
	command mkdir $1 $2
}

mv() {
	command mv $1 $2
}
######################################
#Wrapper functions ends here.
######################################

#Function for Backing-Up.
tar_bup() {
	mkdir -p "$dbpt"
	tar -czpf etc.tar.gz $ipt 2>/dev/null
	mv "$ball" "$dbpt"
	sleep 1
}

#Funtcion for Restoring.
tar_rest() {
	tar -xzpf $dbpt -C ../
	sleep 1
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
			echo "Creating Backup....."
			tar_bup
			echo
			echo -e "Configs Backed-Up at \n$dbpt"

	elif [ $opt == 'Restore' ]
		then
			echo "Restoring Backup..."		
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