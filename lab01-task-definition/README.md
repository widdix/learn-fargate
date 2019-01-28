# Lab 01: ECS Task Definition and IAM Roles

## Goal

Create a task definition containing two containers: the web server and the cache server. Also create the IAM roles for the task and the task execution as well as a CloudWatch log group. Accomplish these tasks by writing a CloudFormation template.

## Instructions

Make sure you are starting from the starting point for Lab 01.

```
cp lab01-task-definition/starting-point/service.yaml service.yaml
```

Extend the CloudFormation template at `service.yaml` with the following resources.

### CloudWatch Log Group

Create a CloudWatch logs group to collect log messages from your tasks and containers. Make sure to define a log retention.

### IAM Role

Create two IAM roles.

1. A task role used to authenticate and authorize AWS API requests from the containers. The role does not need an IAM policy for now, as the containers do not need to access the AWS API.
1. A task execution role used by the container agent to access CloudWatch Logs, ECR, ...

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

* Two containers: `app` and `ambassador`
* Docker image for the `app` container: `widdix/hello:v1`
* Container port for the `app` container: `80 (tcp)`
* Docker image for the `ambassador` container: `eeacms/varnish:4.1-6.2`
* Container port for the `ambassador` container: `6081 (tcp)`
* Environment variable `BACKENDS` for the `ambassador` container: `localhost`
* Environment variable `BACKENDS_PORT` for the `ambassador` container: `80`
* Log driver for both containers: `awslogs`
* The task role and task execution role from the previous step
* Define `0.25` CPU cores and 512 MB memory for the whole task.
* The network mode `awsvpc` is mandatory for the use with Fargate.
* Also add `FARGATE` as a possible launch type.

Use the following command to create a stack based on your template. Replace `$user` with your name (e.g. `andreas`).

```
aws cloudformation create-stack --stack-name service-$user --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-$user ParameterKey=ParentClusterStack,ParameterValue=cluster-$user --template-body file://service.yaml --capabilities CAPABILITY_IAM
```

Manually launch a task in your ECS cluster based on the task definition created by the stack.

Congratulations, you have completed the first lab. Please proceed with the next lab.

## Help
* CloudFormation Resource [AWS::IAM::Role](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html)
* CloudFormation Resource [AWS::Logs::LogGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html)
* CloudFormation Resource [AWS::ECS::TaskDefinition](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html)
* [Amazon ECS Task Execution IAM Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html)
* [Amazon ECS Task Role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_IAM_role.html)
