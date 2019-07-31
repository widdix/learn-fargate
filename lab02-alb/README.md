# Lab 02: Application Load Balancer

## Goal

Create an Application Load Balancer.

## Instructions

Make sure you are starting from the starting point for Lab 02.

```
cp lab02-alb/starting-point/template.yaml template.yaml
```

Extend the CloudFormation template (`template.yaml`) with the following resources.

### ALB's Security Group

Create a security group that allows `TCP` traffic on port `80` from anywhere (`0.0.0.0/0`).

### Application Load Balancer

Create an ALB with the following characteristics:

* Idle timeout: 60 seconds
* Accessible from the Internet (`internet-facing`)
* Attach the security group from above
* Assign all public subnets from the VPC
### ALB Listener

Create an ALB Listener that listens on port `80` using the `HTTP` protocol. Define a default action that returns a fixed response in the form of a HTTP Status Code 404.

Finally, create or update your own ECS stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user
aws cloudformation update-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user
```

Wait until the stack reaches the status `UPDATE_COMPLETE`. Afterwards, use the following command to obtain the URL of your load balancer. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation describe-stacks --stack-name ecs-$user --query 'Stacks[0].Outputs[?OutputKey==`URL`].OutputValue' --output text
```

Open the URL in your browser. You should see a 404 error.

## Help

* CloudFormation Resource [AWS::EC2::SecurityGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html)
* CloudFormation Resource [AWS::ElasticLoadBalancingV2::LoadBalancer](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-loadbalancer.html)
* CloudFormation Resource [AWS::ElasticLoadBalancingV2::Listener](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listener.html)
* CloudFormation Function [Fn::Split](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-split.html)

The following snippet shows an example of how to import the public subnets of the VPC from your `vpc-$user` stack.

```
LoadBalancer:
    Type: 'AWS::ElasticLoadBalancingV2::LoadBalancer'
    Properties:
      Subnets: !Split [',', {'Fn::ImportValue': !Sub '${ParentVPCStack}-SubnetsPublic'}]
```