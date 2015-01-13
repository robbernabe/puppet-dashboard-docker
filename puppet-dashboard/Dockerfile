FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV HOSTNAME dashboard

RUN apt-get update -qq \
  && apt-get install -y -q wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget -O /tmp/puppet.db http://apt.puppetlabs.com/puppetlabs-release-trusty.deb \
  && dpkg -i /tmp/puppet.db \
  && rm -f /tmp/puppet.db

RUN apt-get update -qq && apt-get install -q -y \
  build-essential \
  git \
  libmysqlclient-dev \
  libpq-dev \
  libsqlite3-dev \
  libxml2 \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  postgresql-client \
  ruby1.9.1-dev \
  supervisor

#RUN /usr/bin/puppet config set certname dashboard.local
RUN git clone https://github.com/sodabrew/puppet-dashboard.git /app

COPY ./configs/supervisor/apache2.conf /etc/supervisor/conf.d/apache2.conf
COPY ./configs/supervisor/puppet-dashboard.conf /etc/supervisor/conf.d/puppet-dashboard.conf
COPY ./configs/database.yml /app/config/database.yml
COPY ./configs/settings.yml /app/config/settings.yml
COPY run.sh /usr/local/bin/run.sh

WORKDIR /app

RUN gem install bundler
RUN bundle install --deployment
RUN echo "secret_token: '$(bundle exec rake secret)'" >> config/settings.yml

EXPOSE 3000
