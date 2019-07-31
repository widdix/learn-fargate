# Lab 06: RDS Aurora

## Goal

Connect your ECS service with an RDS Aurora MySQL cluster.

## Instructions

Make sure you are starting from the starting point for Lab 06.

```
cp lab06-rds-aurora/starting-point/template.yaml template.yaml
```

Extend the CloudFormation template (`template.yaml`) with the following resources.

Note that the `template.yaml` template contains new KMS resources `DBKey`, `DBKeyAlias` and the resource `DBSecret` that contains a random password managed by Secrets Manager.

### Task Execution Role needs adjustment

To allow ECS to access the secret password managed by Secrets Manager, you need to adjust the `TaskExecutionRole`. Allow the IAM actions `kms:Decrypt` and `secretsmanager:GetSecretValue`.

### Task Definition needs adjustment

> The sample application was switched from `varnish -> hello app` to an `nginx -> php-fpm` setup that connects to a MySQL database. The MySQL connection requires two environment variables to be present: `RDS_HOSTNAME` and `RDS_PASSWORD`.

Add the two environment variables (`RDS_HOSTNAME` and `RDS_PASSWORD`) to the `app` container definition. Ensure that the database password is never passed around in plain-text!

### Database security group

Define a security group that allows incoming `TCP` traffic on port `3306` from the security group of the service.

### Database subnet group

The database should run in private subnets. You can get the subnet ids with this snippet from the parent VPC stack:

```
!Split [',', {'Fn::ImportValue': !Sub '${ParentVPCStack}-SubnetsPrivate'}]
```

### Database cluster

Define an encrypted MySQL Aurora cluster. The `MasterUserPassword` needs to be fetched from Secrets Manager without making the password visible in plain-text.

### DBInstanceA and DBInstanceB

Define at least two database instances for high availability to join the cluster.

Finally, create or update your own ECS stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
aws cloudformation update-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
```

Wait until the stack reaches the status `UPDATE_COMPLETE`. Afterwards, use the following command to obtain the URL of your load balancer. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation describe-stacks --stack-name ecs-$user --query 'Stacks[0].Outputs[?OutputKey==`URL`].OutputValue' --output text
```

Open the URL in your browser. You should see a page that says "It works!"

# Help

* CloudFormation Property [AWS::ECS::TaskDefinition Secret](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-secret.html)
* CloudFormation Resource [AWS::EC2::SecurityGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html)
* CloudFormation Resource [AWS::RDS::DBSubnetGroup
](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbsubnet-group.html)
* CloudFormation [Dynamic References](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/dynamic-references.html)
* CloudFormation Resource [AWS::RDS::DBCluster](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbcluster.html)
* CloudFormation Resource [AWS::RDS::DBInstance](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-database-instance.html)
