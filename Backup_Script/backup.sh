#! /bin/bash
#Script for backing-up and reinstalling configs, .rc files.
#Its pain in the @$$ to configure your configs, rc, aliases etc files after reinstalling Termux.
#A Barebone script which will be improved in the near future.
#Written by Sars!
#0.1

#GLOBAL VARIABLES
#Import the config file containing backup path.
source ~/.Backup_Utility/.config

#Path from where the files needs to be backed up.
ipt=../usr/etc/

#Move the archive to TermuxStuff
ball=~/etc.tar.gz

#Choices
chc="Backup Restore Quit"
PS3="Choose: "

#######################################
#Wrapper functions starts from here, will be utilized later in the script.

ls() {
	command ls -lh
}

dl() {
	rm -r
}

mkdir() {
	command mkdir -p $dbpt 2>/dev/null
}

mv() {
	command mv $ball $dbpt
}
#Wrapper functions ends here.
######################################

#Function for Backing-Up.
tar_bup() {

	echo "Creating Backup....."
	mkdir
	tar -czpf etc.tar.gz $ipt 2>/dev/null
	mv
	sleep 1
	echo
	echo -e "Configs Backed-Up at \n$dbpt"
	
}

#Funtcion for Restoring.
tar_rest() {

	echo "Restoring Backup..."		
	tar -xzpf $dbpt -C ../
	sleep 1
	echo -e "\nConfigs Restored!"

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
		tar_bup

	elif [ $opt == 'Restore' ]
	then
		tar_rest
	fi
done