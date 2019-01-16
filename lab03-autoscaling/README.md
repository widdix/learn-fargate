# Lab 03: Auto Scaling for ECS Service

## Goal

Make sure your ECS service scales the number of tasks based on CPU utilization.

## Instructions

Make sure you are starting from the starting point for Lab 01.

```
cp lab03-autoscaling/starting-point/service.yaml service.yaml
```

Extend the CloudFormation template at `service.yaml` with the following resources.

Note that the `service.yaml` template contains a new IAM role named `ScalableTargetRole` which can be used by the scalable target to scale the number of tasks.

### Scalable Target

Create a scalable target for your ECS service. See [API Reference ScalableTarget](https://docs.aws.amazon.com/autoscaling/application/APIReference/API_ScalableTarget.html) for details.

### Scaling Policy

Define two scaling policies: one policy to scale up and another policy to scale down. Use the `PercentChangeInCapacity` adjustment type.

### CloudWatch Alarm

Create two CloudWatch alarms: one alarm to trigger the scale up policy and another alarm to trigger the scale down policy.

Use the following command to update your service stack based on your template. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation update-stack --stack-name service-$user --parameters ParameterKey=ParentVPCStack,UsePreviousValue=true ParameterKey=ParentClusterStack,UsePreviousValue=true --template-body file://service.yaml --capabilities CAPABILITY_IAM
```

Wait until the stack reaches the status `UPDATE_COMPLETE`.

Congratulations, you have completed the second lab.

## Help

* CloudFormation Resource [AWS::ApplicationAutoScaling::ScalableTarget](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-applicationautoscaling-scalabletarget.html)
* CloudFormation Resource [AWS::ApplicationAutoScaling::ScalingPolicy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-applicationautoscaling-scalingpolicy.html)
* CloudFormation Resource [AWS::CloudWatch::Alarm](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html)
