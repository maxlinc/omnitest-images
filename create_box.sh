#!/bin/bash

set -e

bundle exec berks vendor

#export PACKER_LOG=1
rm -rf output-virtualbox-iso
rm packer_virtualbox_virtualbox.box || true
packer build -only=virtualbox-iso packer-crosstest-ubuntu.json
vagrant box remove crosstest-ubuntu || true
vagrant box add crosstest-ubuntu packer_virtualbox_virtualbox.box

