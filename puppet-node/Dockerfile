FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
  && apt-get install -y -q wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget -O /tmp/puppet.db http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb \
  && dpkg -i /tmp/puppet.db \
  && rm -f /tmp/puppet.db
RUN apt-get update -qq \
  && apt-get install -y -q puppet \
  && rm -rf /var/lib/apt/lists/*
RUN /usr/bin/puppet config set server dashboard
