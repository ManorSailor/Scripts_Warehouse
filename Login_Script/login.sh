#! /bin/bash
#Login script which asks for the usrnm & pswd which the user defines, it terminates the app if credentials dont match.
#It has improved now, but still not totally foolproof. 
#Version: 0.3

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

#Trap the intruder ;)
int_trp() {
	echo "Intruder Alert!!"
	sleep 3
	kill -9 $PPID
}

#Function for checking if the user is authorized.
chk_crd() {
	trap 'int_trp' INT

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
}

#Checks if the user is running the script for first time, it's not the proper way of doing this i guess but for now it works :P
if [ -f "$pt" ];
then
	chk_crd
else
	st_crd
fi

trap SIGINT
