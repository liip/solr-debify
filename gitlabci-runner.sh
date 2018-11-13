#!/bin/sh

set -e

finish() {
    date
    echo "* Cleanup the solr-build directory"
    vagrant ssh -c "rm -Rf ./build/*" || :
    echo "* Halt"
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

RESULTDIR=./results

echo "* Output the Debian version"
vagrant ssh -c "cat /etc/debian_version"

echo "* Cleanup $RESULTDIR directory"
[ ! -d $RESULTDIR ] || rm -Rf $RESULTDIR

mkdir -p $RESULTDIR

echo "* Cleanup the solr-build directory"
vagrant ssh -c "rm -Rf ./build/*"

echo "* Get the original source"
vagrant ssh -c "cd solr-build; ./debian/rules get-orig-source"

echo "* Apply patches"
vagrant ssh -c "cd solr-build; QUILT_PATCHES=debian/patches quilt push -af" || :

echo "* Build the package"
vagrant ssh -c "cd solr-build; pdebuild --debbuildopts \"-nc\" --buildresult /vagrant/$RESULTDIR -- --use-network yes"

echo "* Purge previous package traces"
vagrant ssh -c "sudo apt-get -y purge solr; sudo rm -Rf /var/lib/solr /var/log/solr"

echo "* Install the package in the vagrant box"
vagrant ssh -c "sudo dpkg -i solr_*_all.deb; sudo apt-get install -f -y"

echo "* Test that the webinterface is up"
vagrant ssh -c "HEAD 'http://localhost:8983/solr/'"

echo "* Attempt SSH to the destination host"

tmpkey=$(mktemp)
eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" > $tmpkey
ssh-add $tmpkey
rm -f $tmpkey
ssh -o StrictHostKeyChecking=no -p 2201 liip@solr-packages.liip.ch echo 'OK'

echo "* Upload the unsigned packages"
for c in $RESULTDIR/*.changes; do
    echo "  - $c"
    for f in $(grep -A1000 'Files:' $c | tail -n+2 | cut -f6 -d' '); do
        echo "    -> $f"
        scp -o StrictHostKeyChecking=no -P 2201 \
            $RESULTDIR/$f \
            liip@solr-packages.liip.ch:~/solr-packages-incoming/
    done
    echo "    -> $c"
    scp -o StrictHostKeyChecking=no -P 2201 \
        $c \
        liip@solr-packages.liip.ch:~/solr-packages-incoming/
done
