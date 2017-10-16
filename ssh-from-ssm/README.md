# ssh-from-ssm
This could be a possible solution in production environment to get access to an ec2 instance without deploying a bastion host or opening security groups for ssh.

# sources 
https://aws.amazon.com/de/blogs/mt/replacing-a-bastion-host-with-amazon-ec2-systems-manager/

# what is needed
- policy on the instance profile (arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM)
- installation of the ssm client in userdata part
- creation of a s3 bucket
- creation of a sns topic

# get access via cli
http://www.awsomeblog.com/amazon-ec2-simple-systems-manager/
- aws ssm create-document --content file://command.json --name "custom" --region eu-central-1 (using self created document)
- aws ssm send-command --document-name "AWS-RunShellScript" --parameters '{"commands":["ifconfig","df -h","uname -a"],"executionTimeout":["3600"]}' --timeout-seconds 600 --output-s3-bucket-name "arn:aws:s3:::ssm-test" --service-role-arn "arn:aws:iam::123456789:role/aws-ssm-SnsNotificationRole" --notification-config '{"NotificationArn":"arn:aws:sns:eu-central-1:123456789:snsTopic","Events":["All"],"NotificationType":"Command"}' --region eu-central-1
- aws ssm list-command-invocations --command-id "6f1e139b-77d1-440f-83e4-4eef3d94a9c8" --details

# downsides of bastion hosts

- Like any other infrastructure host, it must be managed and patched.
- It accrues a cost while it is running.
- Each of your security groups that allow bastion access require a security group ingress rule, normally port 22 for SSH (usually for Linux) or port 3389 for RDP (usually for Windows hosts).
- Private RSA keys for the bastion host and application hosts need to be managed, protected, and rotated.
- SSH activity isn’t natively logged.

# benefits of this solution

- This approach uses an AWS managed service, meaning that the Systems Manager components are reliable and highly available.
- Systems Manager requires an IAM policy that allows users or roles to execute commands remotely.
- Systems Manager agents require an IAM role and policy that allow them to invoke the Systems Manager service.
- Systems Manager immutably logs every executed command, which provides an auditable history of commands, including:
    - The executed command
    - The principal who executed it
    - The time when the command was executed
    - An abbreviated output of the command
- When AWS CloudTrail is enabled to record and log events in the region where you’re running Systems Manager, every event is recorded by CloudTrail and logged in Amazon CloudWatch Logs.
- Using CloudTrail and CloudWatch rules gives you the ability to use Systems Manager events as triggers for automated responses, such as Amazon SNS notifications or AWS Lambda function invocations.
- Systems Manager can optionally store command history and the entire output of each command in Amazon S3.
- Systems Manager can optionally post a message to an SNS topic, notifying subscribed individuals when commands execute and when they complete.
- Systems Manager is agent-based, which means it is not restricted to Amazon EC2 instances. It can also be used on non-AWS hosts that reside on your premises, in your data center, in another cloud service provider, or elsewhere.
- You don’t have to manage SSH keys.
- Possibility to manage commands with the cli
- Also works in private subnets
