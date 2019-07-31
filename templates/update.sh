#!/bin/bash -ex

# Fetches CloudFormation templates from https://github.com/widdix/aws-cf-templates

rm vpc-2azs.yaml && wget https://s3-eu-west-1.amazonaws.com/widdix-aws-cf-templates-releases-eu-west-1/stable/vpc/vpc-2azs.yaml
