#!/bin/bash

mypwd="password"
read -s -p "Enter password: " getpassword
echo ""
if [ "$getpassword" = "$mypwd" ] ; then
	echo "Continue..."
else
	echo "You are not authorized!" && echo "exiting.." 
	exit 1;
fi

# Configure AWS connection...
aws configure

# Declare configuration variables

CURRENT_IP=$(curl -s https://ifconfig.me.)
NEW_IP="$CURRENT_IP/32"
Echo "Your WAN IP is $NEW_IP"

OLD_IP=""

# Read old ip from a file named .recentip
if test -f ".recentip" ; then
	OLD_IP=`cat ./.recentip`
else
	# Get old ip from the user
	read -p "Enter OLD IP (format: x.x.x.x/32): " OLD_IP
	echo ""
fi

# Write this new ip to file .recentip
echo "$NEW_IP" > ./.recentip

# Read old ip from a file named .amazonsg
if test -f ".amazonsg" ; then
	SECURITY_GROUP_ID=`cat ./.amazonsg`
else
	# Get Security group ID from the user
	read -p "Enter Security Group ID: " SECURITY_GROUP_ID
	echo ""
fi

# Write this Security group to file .amazonsg
echo "$SECURITY_GROUP_ID" > ./.amazonsg

# Ports for ingress and outgress must be read from file .ingress and .egress
# if files doesn't exist then it should be read from console

# For INGRESS RULES 
if test -f ".ingress" ; then
	# read ports from file .ingress
	# In the file .ingress, enter port numbers separated by space in the same line 
	ingress_ports=`cat ./.ingress`
	ingress_ports_arr=( $ingress_ports ) 
else
	touch ./.ingress
	read -r -p "Enter port numbers separated by space for INGRESS rules: " -a ingress_ports_arr
	for port in "${ingress_ports_arr[@]}"; do
		echo "port is $port"
	
		# Write ports in file .ingress
		echo "$port" >> ./.ingress
	done 
fi


Echo "Revoking ingress rules of OLD IP: $OLD_IP"
while true;  
do
	read -p "Are you sure (Y/N)?" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) break;;
		* ) echo "Please enter answer Y or N:";;
	esac
done
	
	
if [ $ans == "Y" -o $ans == "y" ]; then	
	for port in "${ingress_ports_arr[@]}"; do
		Echo "Revoking ingress rule on port $port.."
		aws ec2 revoke-security-group-ingress --protocol tcp --port $port --cidr $OLD_IP --group-id $SECURITY_GROUP_ID
	done
fi

	
Echo "Setting ingress rules of NEW IP: $NEW_IP"
while true;  
do
	read -p "Are you sure (Y/N)?" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) break;;
		* ) echo "Please enter answer Y or N:";;
	esac
done
	
	
if [ $ans == "Y" -o $ans == "y" ]; then	
	for port in "${ingress_ports_arr[@]}"; do
		Echo "Setting ingress rule on port $port.."
		aws ec2 authorize-security-group-ingress --protocol tcp --port $port --cidr $NEW_IP --group-id $SECURITY_GROUP_ID 
	done
fi


# For EGRESS RULES 
if test -f ".egress" ; then
	# read ports from file .egress
	# In the file .egress, enter port numbers separated by space in the same line 
	egress_ports=`cat ./.egress`
	egress_ports_arr=( $egress_ports ) 
else
	touch ./.egress
	read -r -p "Enter port numbers separated by space for EGRESS rules: " -a egress_ports_arr
	for port in "${egress_ports_arr[@]}"; do
		echo "port is $port"
	
		# Write ports in file .egress
		echo "$port" >> ./.egress
	done 
fi

Echo "Revoking egress rules of OLD IP: $OLD_IP"
while true;  
do
	read -p "Are you sure (Y/N)?" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) break;;
		* ) echo "Please enter answer Y or N:";;
	esac
done
	
	
if [ $ans == "Y" -o $ans == "y" ]; then	
	for port in "${egress_ports_arr[@]}"; do
		Echo "Revoking egress rule on port $port.."
		aws ec2 revoke-security-group-egress --protocol tcp --port $port --cidr $OLD_IP --group-id $SECURITY_GROUP_ID
	done
fi

	
Echo "Setting egress rules NEW IP: $NEW_IP"
while true;  
do
	read -p "Are you sure (Y/N)?" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) break;;
		* ) echo "Please enter answer Y or N:";;
	esac
done
	
	
if [ $ans == "Y" -o $ans == "y" ]; then	
	for port in "${egress_ports_arr[@]}"; do
		Echo "Setting egress rule on port $port.."
		aws ec2 authorize-security-group-egress --protocol tcp --port $port --cidr $NEW_IP --group-id $SECURITY_GROUP_ID 
	done
fi



exit 0;

