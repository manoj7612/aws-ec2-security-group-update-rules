# aws-ec2-security-group-update-rules
# Description

Update AWS Security Group with a dynamic public IP received everytime the router is restarted. It will ask for your OLD IP, check your NEW IP and ask for Ingress and Egress ports you wish to update for the NEW IP. It will then revoke the given Ingress and Egress rules for the OLD IP and set the rules for the NEW IP.  

Therefore, AWS Security Groups can be dynamically configured using this script for dynamic IP and required ports.  

# Dependencies

You need to install AWS CLI and CYGWIN for running it from your Windows PC.

# Installation:

Create a new directory where you want to install the script.

Clone the repository 
```
git clone https://github.com/manoj7612/aws-ec2-security-group-update-rules.git
cd aws-ec2-security-group-update-rules/

```

# Usage
 
The script is password protected.  The default password is 'password'.  You can change the password and create a binary executable of it using the following command (shc must be installed):
```
shc -v -r -T -f update_aws_sg.sh
``` 
It will generate two files:
```
update_aws_sg.sh.x
update_aws_sg.sh.x.c
```



Run the script:
```
./update_aws_sg.sh.x
```
When you run the script, it will ask for the following options:

```  
  Enter password:
  
  AWS Access Key ID
  AWS Secret Access Key
  Default region name
  Default output format
  
  Enter OLD IP (format: x.x.x.x/32):
  
  Enter Security Group ID:
  
  Enter port numbers separated by space for INGRESS rules:
	  Revoking ingress rules of OLD IP: 
	  Are you sure (Y/N)?

	  Setting ingress rules of NEW IP:
	  Are you sure (Y/N)?

  Enter port numbers separated by space for EGRESS rules:
  
	  Revoking egress rules of OLD IP: 
	  Are you sure (Y/N)?

	  Setting egress rules NEW IP: 
	  Are you sure (Y/N)?
```

# Contributing

Contributions are welcome!

# License

GNU General Public License v3.0
