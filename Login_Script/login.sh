#! /bin/bash
#Simple login script which asks for the predefined usrnm & pswd
#it terminates the app if credentials dont match.
#It has improved now, but still not totally foolproof. 
#Version: 0.3

int_trp() {
	echo "Interrupted"
	sleep 3
	kill -9 $PPID
}

trap 'int_trp' INT

echo "Username"
read n
echo "Password"
read -s p

#enter your credentials here
if [[ $n == "Ali" && $p == "Sars" ]];
then
echo "Access Granted!"

else
echo "Un-Authorized User... Exiting"
sleep 3
#kills the parent process id i.e., the app itself.
kill -9 $PPID 
fi

trap SIGINT
