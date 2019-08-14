#! /bin/bash
#Login script which asks for the usrnm & pswd defined by the user, it terminates the app if credentials dont match.
#It has improved now, but still not totally foolproof. 
#Version: 0.5

#Path where the valuables are stored.
pt=../usr/share/.login

#Function that sets credentials.
st_crd() {
	read -p "Set Your Username: " un
	read -s -p "Set Your Password: " pf

	if [[ $un != "" && $pf != "" ]];
	then
		touch $pt
	        echo -e "$un\n$pf" >> $pt
	        echo -e "\nCredentials added!!"
		echo -e "\nExiting Termux, please restart it!"
		sleep 3
		kill -9 $PPID
	else
		echo -e '\nCredentials cannot be empty!'
		exit
	fi

}

#Function for re-setting credentials
rst_crd() {
	read -p "Enter Old Usrname OR Password: " old

	#Read the cred.
	unm=$( head -n 1 $pt )
	p=$( tail -n 1 $pt )

	if [[ $old == $unm || $old == $p ]];
	then
		echo -e "\nClearing your Old Credentials..."
		rm -rf $pt
		echo -e "\nCleared! Please add your new credentials"
		st_crd

	else
		echo -e "\nOh, you remember your Credentials? :o"
		echo -e "\nClosing app, re-launch it please"
		sleep 3
		kill -9 $PPID
	fi
}

#Trap the intruder & check if user wants to reset Credentials ;)
int_trp() {
	echo -e "\nForgot your Credentials?"
	read ans

	if [[ $ans == "yes" || $ans == "y" || $ans == "Y" || $ans == "Yes" ]];
	then
		rst_crd

	else
		echo "Intruder Alert!!"
		sleep 3
		kill -9 $PPID
	fi
}

#Function for checking if the user is authorized.
chk_crd() {
	trap 'int_trp' INT
	chmod u+rw $pt

	unm=$( head -n 1 $pt )
	p=$( tail -n 1 $pt )

	echo "Enter Un"
	read n
	echo "Enter Passwd"
	read -s pss

	if [[ $n == $unm && $pss == $p ]];
	then
		echo "Access Granted!"

	else
		echo "Un-Authorized User ..exiting"
		sleep 3
		kill -9 $PPID
	fi
	chmod u-rw $pt
}

#Checks if the user is running the script for first time, it's not the proper way of doing this i guess but for now it works :P
if [ -f "$pt" ];
then
	chk_crd

else
	st_crd
fi

trap SIGINT
