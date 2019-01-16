#!/bin/bash -ex

yamllint *.yaml
cfn-lint -i E1019 E3002 E2520 -t *.yaml
