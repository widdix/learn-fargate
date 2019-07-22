#!/bin/bash -ex

yamllint *.yaml
cfn-lint -t *.yaml
