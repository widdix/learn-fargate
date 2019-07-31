# Lab 03: ECS Task Definition and IAM Roles

## Goal

Create a task definition containing two containers: the web server and the cache server. Also create the IAM roles for the task and the task execution as well as a CloudWatch log group. Accomplish these tasks by writing a CloudFormation template.

## Instructions

Make sure you are starting from the starting point for Lab 03.

```
cp lab03-task-definition/starting-point/template.yaml template.yaml
```

Extend the CloudFormation template (`template.yaml`) with the following resources.

### CloudWatch Log Group

Create a CloudWatch logs group to collect log messages from your tasks and containers. Make sure to define a log retention.

### IAM Role

Create two IAM roles.

1. A task execution role used by the container agent to access CloudWatch Logs, ECR, ...

1. A task role used to authenticate and authorize AWS API requests from the containers. The role does not need an IAM policy for now, as the containers do not need to access the AWS API.

Add the following policy to the task execution role. Restrict access to the CloudWatch log group from the previous section.

```
{
    "Statement": [
        {
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "..."
        }
    ]
}
```

### ECS Task Definition

Create a task definition as a blue print to launch tasks within your ECS cluster. The task definition should include the following details.

* Two containers: `app` and `proxy`
* Docker image for the `app` container: `widdix/hello:v1`
* Container port for the `app` container: `80 (tcp)`
* Docker image for the `proxy` container: `eeacms/varnish:4.1-6.2`
* Container port for the `proxy` container: `6081 (tcp)`
* Environment variable `BACKENDS` for the `proxy` container: `localhost`
* Environment variable `BACKENDS_PORT` for the `proxy` container: `80`
* Log driver for both containers: `awslogs`
* The task role and task execution role from the previous step
* Define `0.25` CPU cores and 512 MB memory for the whole task.
* The network mode `awsvpc` is mandatory for the use with Fargate.
* Also add `FARGATE` as a possible launch type.

Finally, create or update your own ECS stack. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
aws cloudformation update-stack --stack-name ecs-$user --template-body file://template.yaml --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user --capabilities CAPABILITY_IAM
```

Manually launch a task in your ECS cluster (select a public Subnet of your VPC, and assign a public IP address) based on the task definition created by the stack.

## Help
* CloudFormation Resource [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html)
* CloudFormation Resource [AWS::Logs::LogGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html)
* CloudFormation Resource [AWS::ECS::TaskDefinition](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html)
* [Amazon ECS Task Execution IAM Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html)
* [Amazon ECS Task Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_IAM_role.html)
