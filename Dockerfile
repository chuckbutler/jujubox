FROM ubuntu:14.04.2
MAINTAINER Adam Israel <adam.israel@canonical.com>
RUN apt-get update && apt-get -y --no-install-recommends install \
    bzr \
    ca-certificates \
    git \
    golang-go \
    golang-src \
    mercurial \
    make \
    openssh-client

ENV HOME=/home/ubuntu
ENV GOPATH=/home/ubuntu/go
ENV GOROOT=/usr/lib/go
ENV JUJU_BRANCH=feature-proc-mgmt

# Setup the user
ADD setup.sh /
RUN /setup.sh

# Make ~.juju persistent
# This will need a local directory, mapped to via docker run
VOLUME ["/home/ubuntu/.juju"]

ADD run.sh /

CMD /run.sh
