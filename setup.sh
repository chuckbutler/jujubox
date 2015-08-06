#!/bin/bash

apt-get update -qq
apt-get install -qy software-properties-common
apt-add-repository -y ppa:juju/stable
apt-get update -qq

## don't install lxc & local till we get local support
#apt-get install -qy lxc iptables juju-local
apt-get -qy install juju-deployer
apt-get -qy install byobu charm-tools openssh-client
apt-get -qy install virtualenvwrapper python-dev cython git

useradd -m ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/juju-users


mkdir -p /home/ubuntu/.juju
mkdir -p /home/ubuntu/.go

HOME=/home/ubuntu

git clone https://github.com/juju/plugins.git ${HOME}/.juju-plugins
RC=${HOME}/.bashrc
echo "export JUJU_HOME=${HOME}/.juju" >> $RC
echo "export JUJU_REPOSITORY=${HOME}" >> $RC

mkdir -p $HOME/.go
export GOPATH=$HOME/.go
export GOROOT=/usr/lib/go

apt-get -qy install juju-core juju-quickstart juju-deployer

# Fetch latest code
go get launchpad.net/godeps/...
mkdir -p $HOME/.go/src/github.com/juju/
git clone https://github.com/juju/juju $HOME/.go/src/github.com/juju/juju
cd $HOME/.go/src/github.com/juju/juju

git checkout $JUJU_BRANCH

# Build!
JUJU_MAKE_GODEPS=true make godeps
make build
make install

echo "export PATH=${HOME}/.go/bin:$PATH:${HOME}/.juju-plugins" >> $RC


# CLEANUP
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
