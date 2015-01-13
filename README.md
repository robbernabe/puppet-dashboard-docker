# puppet-dashboard evaluation

This is a docker-based setup to be used for evaluating [Puppet Dashboard](https://github.com/sodabrew/puppet-dashboard). It also makes use of [fig](http://www.fig.sh/) to manage the containers because:

* it's cool
* I wanted to learn it
* it makes it much easier to manage multiple containers

## requirements

* [VirtualBox](https://www.virtualbox.org/)
* [boot2docker](http://boot2docker.io/)
* [fig](http://www.fig.sh/)

## how to

First, install boot2docker using the official installer for OS X.  Then:

	boot2docker init
	boot2docker start
	eval $(boot2docker shellinit)

Docker should be ready to go. Next step is to install fig. Follow the directions
on the website to do so (it's a one-liner I believe).

Now to start the puppetmaster container:

	fig build
	fig run dashboard bundle exec rake db:setup
	fig up --no-recreate -d

This will create the database and run the migrations. Fig takes care of starting both the
app and database contianers for you. The database container will stay running, and we don't
want to blow it away since the data is in the database container.  This is why the following
command `fig up --no-recreate -d` includes the 'no-recreate' option, so we don't recreate
the database container, destroying the initial dataset we've created.

And finally, to get puppet-dashboard running:

	./initialize.sh

See that script for more details about what it's doing.

## accessing the application

Since boot2docker uses a VirtualBox vm to run docker, you'll need to use the
host-only network provided to access the Puppet Dashboard UI:

	❯ boot2docker ip
	192.168.59.103
	❯

You can now access the dashboard at http://192.168.59.103:3000 (be sure to use
the IP address displayed from the `boot2docker ip` command you ran above).
