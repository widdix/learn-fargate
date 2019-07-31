#!/bin/bash -ex

yamllint lab*/sample-solution/template.yaml
cfn-lint -t lab*/sample-solution/template.yaml
