# Lab 02: ECS Service and Application Load Balancer (ALB)

## Goal

Create an ECS service and make sure the Application Load Balancer (ALB) routes requests to the tasks.

## Instructions

Make sure you are starting from the starting point for Lab 02.

```
cp lab02-service/starting-point/service.yaml service.yaml
```

Extend the CloudFormation template at `service.yaml` with the following resources.

### ALB Target Group

Create a target group with the following configuration parameters:

* Path for health check: `/`
* Protocol for health check: `HTTP`
* OK status codes for health check: `200-299`
* De-registration delay: `30 seconds`

You will also need to specify the VPC for the target group. Do so, by using the export `vpc-$user-VPC` of your VPC stack.

### ALB Listener Rule

Create a listener rule which forwards all requests matching the path pattern `*` to the target group you created in the previous step.

You will also need to specify the ECS cluster id for the listener rule. Do so, by using the export `cluster-$user-HttpListener` of your cluster stack.

### Security Group

Create a security group which allows incoming `TCP` traffic on port `6081` from the load balancer.

You will also need to specify the security group id of the load balancer. Do so, by using the export `cluster-$user-LoadBalancerSecurityGroup` of your cluster stack.

### ECS Service

Create an ECS service which starts two tasks based on the task definition you created in lab 01. Also make sure to use the following configuration for the service:

* Launch type: `FARGATE`
* Register port `6081` the `proxy` container at the target group
* Add the security group from the previous section
* Set `TargetType` to `ip`
* Make sure the service starts task with a Public IP in one of your public subnets.

You will need to specify the ids of the public subnets. Do so, by using the export `vpc-$user-SubnetsPublic` of your cluster stack.

Use the following command to update your service stack based on your template. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation update-stack --stack-name service-$user --parameters ParameterKey=ParentVPCStack,UsePreviousValue=true ParameterKey=ParentClusterStack,UsePreviousValue=true --template-body file://service.yaml --capabilities CAPABILITY_IAM
```

Wait until the stack reaches the status `UPDATE_COMPLETE`. Afterwards, use the following command to obtain the URL of your load balancer. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation describe-stacks --stack-name cluster-andreas --query 'Stacks[0].Outputs[?OutputKey==`URL`].OutputValue' --output text
```

Open the URL in your browser. It works!

Congratulations, you have completed the second lab. Please proceed with the next lab.

## Help

* CloudFormation Resource [AWS::ElasticLoadBalancingV2::TargetGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-targetgroup.html)
* CloudFormation Resource [AWS::ElasticLoadBalancingV2::ListenerRule](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listenerrule.html)
* CloudFormation Resource [AWS::EC2::SecurityGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html)
* CloudFormation Resource [AWS::ECS::Service](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html)
* CloudFormation Function [Fn::Split](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-split.html)

The following snippet shows an example of how to import the ID of the VPC from your `vpc-$user` stack.

```
TargetGroup:
  Type: 'AWS::ElasticLoadBalancingV2::TargetGroup'
  Properties:
    VpcId: {'Fn::ImportValue': !Sub '${ParentVPCStack}-VPC'}
```
