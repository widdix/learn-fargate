# learn-fargate

Labs helping you to learn AWS Fargate within a few hours.

Are you looking for an instructor-led workshop based on these labs? Say [hello@widdix.net](mailto:hello@widdix.net).

> Raise the VPCs per region limit if you run this lab with a larger group of people!

## Labs

* [Lab 01: ECS Cluster](lab01-cluster/)
* [Lab 02: Application Load Balancer](lab02-alb/)
* [Lab 03: ECS Task Definition and IAM Roles](lab03-task-definition/)
* [Lab 04: ECS Service and Application Load Balancer (ALB)](lab04-service/)
* [Lab 05: Auto Scaling for ECS Service](lab05-autoscaling/)
* [Lab 06: RDS Aurora](lab06-rds-aurora/)

## Setup your personal lab environment

Clone or [download](https://github.com/widdix/learn-fargate/archive/master.zip) this repository on your local machine.

Open the AWS Management Console of an empty AWS account.

Create your own VPC stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name vpc-$user --template-body file://templates/vpc-2azs.yaml
```

Wait until the stack reached the status `CREATE_COMPLETE`.

You are now ready for the first lab.

## Clean up

Use the following commands to delete your stacks. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation delete-stack --stack-name ecs-$user
```

Wait until the stack has been deleted.

```
aws cloudformation delete-stack --stack-name vpc-$user
```

## More Labs

We offer AWS workshops tailored to your needs. See [widdix/learn-*](https://github.com/widdix?q=learn-) for more labs.
