# learn-fargate

Labs helping you to learn AWS Fargate within a few hours.

Are you looking for an instructor-led workshop based on these labs? Say [hello@widdix.net](mailto:hello@widdix.net).

## Labs

* [Lab 01: ECS Task Definition and IAM Roles](lab01-task-definition/)
* [Lab 02: ECS Service and Application Load Balancer (ALB)](lab02-service/)
* [Lab 03: Auto Scaling for ECS Service](lab03-autoscaling/)

## Setup your personal lab environment

Create your own VPC stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name vpc-$user --template-body file://templates/vpc-2azs.yaml
```

Wait until the stack reached the status `CREATE_COMPLETE`.

Create your own ECS cluster stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name cluster-$user --template-body file://templates/cluster.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
```

You are now ready for the first lab.

## Clean up

Use the following commands to delete your stacks. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation delete-stack --stack-name service-$user
```

Wait until the stack has been deleted.

```
aws cloudformation delete-stack --stack-name cluster-$user
```

Wait until the stack has been deleted.

```
aws cloudformation delete-stack --stack-name vpc-$user
```
