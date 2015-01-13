#!/bin/bash -e

# Grab out container names
DASH=$(fig ps | grep run.sh | awk '{print $1}')
AGENT=$(fig ps | grep true | awk '{print $1}')

# Install puppet when we run the container to avoid that annoying SSL cert issue
# I know this isn't ideal, but fine for testing out the dashboard :P
docker exec -ti $DASH apt-get update -qq
docker exec -ti $DASH apt-get install -y puppetmaster-passenger

# Setup the Puppetmaster to process reports
docker exec -ti $DASH /usr/bin/puppet config set certname dashboard.local
docker exec -ti $DASH /usr/bin/puppet config set reports store,http --section master
docker exec -ti $DASH /usr/bin/puppet config set reporturl http://dashboard:3000/reports/upload --section master

# Setup the agent to send reports
docker exec -ti $AGENT /usr/bin/puppet config set report true

# We're running with RAILS_ENV=production, so compile assets per the docs
docker exec -ti $DASH bundle exec rake assets:precompile

# Restart all apps (puppet-dashboard and puppetmaster)
docker exec -ti $DASH supervisorctl restart all

# Initial connection to the puppetmaster
docker exec -ti $AGENT /usr/bin/puppet agent --test

# Puppetmaster signs the cert
docker exec -ti $DASH /usr/bin/puppet cert sign agent1

# First (hopefully) successful run that will generate a report to show in the UI
docker exec -ti $AGENT /usr/bin/puppet agent --test

# Start the worker to process the reports
docker exec -ti $DASH script/delayed_job -p dashboard -n 4 -m start

