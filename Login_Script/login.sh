#! /bin/bash
#Simple login script which asks for the predefined usrnm & pswd
#it terminates the app if credentials dont match.
#Its not foolproof anyone with basic linux knowledge can bypass it, just by issuing Cancel command ( ctrl + c ).
#Version: 0.1 Initial Release

echo "Username"
read n
echo "Password"
read p

if [[ $n == "Ali" && $p == "Sars" ]]; #enter your credentials here
then
echo "Access Granted!"

else
echo "Un-Authorized User... Exiting"
sleep 3
kill -9 $PPID #kills the parent process id i.e., the app itself
fi
