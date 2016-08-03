#!/bin/sh

set -e

finish() {
    date
    vagrant halt
    date
}

set -e
trap finish EXIT INT

export VIRTUALIZATION_PARAMETERS_FILE=virtualization/parameters.yml

date
vagrant up  --provider lxc
date
vagrant provision
date

echo "Get the original source"
vagrant ssh -c "./debian/rules get-orig-source"

echo "Build the package"
mkdir binarybuilds
vagrant ssh -c "BUILD_DESTDIR=./binarybuilds dpkg-buildpackage -b"
