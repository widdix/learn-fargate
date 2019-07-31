# Lab 05: Auto Scaling for ECS Service

## Goal

Make sure your ECS service scales the number of tasks based on CPU utilization.

## Instructions

Make sure you are starting from the starting point for Lab 05.

```
cp lab05-autoscaling/starting-point/template.yaml template.yaml
```

Extend the CloudFormation template (`template.yaml`) with the following resources.

Note that the `template.yaml` template contains a new IAM role named `ScalableTargetRole` which can be used by the scalable target to scale the number of tasks.

### Scalable Target

Create a scalable target for your ECS service. See [API Reference ScalableTarget](https://docs.aws.amazon.com/autoscaling/application/APIReference/API_ScalableTarget.html) for details.

### Scaling Policy

Define two scaling policies: one policy to scale up and another policy to scale down. Use the `PercentChangeInCapacity` adjustment type.

### CloudWatch Alarm

Create two CloudWatch alarms: one alarm to trigger the scale up policy and another alarm to trigger the scale down policy.

Finally, create or update your own ECS stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
aws cloudformation update-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
```

Wait until the stack reaches the status `UPDATE_COMPLETE`.

## Help

* CloudFormation Resource [AWS::ApplicationAutoScaling::ScalableTarget](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-applicationautoscaling-scalabletarget.html)
* CloudFormation Resource [AWS::ApplicationAutoScaling::ScalingPolicy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-applicationautoscaling-scalingpolicy.html)
* CloudFormation Resource [AWS::CloudWatch::Alarm](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html)
