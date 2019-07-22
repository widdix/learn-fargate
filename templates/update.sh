#!/bin/bash -ex

# Fetches CloudFormation templates from https://github.com/widdix/aws-cf-templates

rm cluster.yaml && wget https://s3-eu-west-1.amazonaws.com/widdix-aws-cf-templates-releases-eu-west-1/stable/fargate/cluster.yaml
rm vpc-2azs.yaml && wget https://s3-eu-west-1.amazonaws.com/widdix-aws-cf-templates-releases-eu-west-1/stable/vpc/vpc-2azs.yaml

# Check the diffs, make sure you are not overriding customizations
