# Lab 01: ECS Cluster

## Goal

Create an ESC cluster.

## Instructions

Make sure you are starting from the starting point for Lab 01.

```
cp lab01-cluster/starting-point/template.yaml template.yaml
```

Extend the CloudFormation template (`template.yaml`) with the following resources.

### ECS Cluster

Define an ECS Cluster and with the required properties.

Finally, create your own ECS stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name ecs-$user --template-body file://template.yaml
```

## Help
* CloudFormation Resource [AWS::ECS::Cluster](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html)
