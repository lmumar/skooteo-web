# Development

## Setting Up

* Ruby version `2.5.1`
  * If you are using RVM (rvm.io), use `rvm install 2.5.1` to install ruby
* Download the `skooteo-firebase.json` and place it on `/opt/skooteo` directory
* Tested node version v11.3.0
* System dependencies
  * redis, minimum version _3.0_
    * MacOS `brew install redis`
  * postgresql, minimum version _9.5_
    * MacOS: `brew install postgresql`
    * Linux (Ubuntu):
    ```
    $ sudo apt install postgresql postgresql-contrib libq-dev
    ```
  * postgis
    * MacOS: `brew install postgis`
    * Linux:
      ```
      $ sudo add-apt-repository ppa:ubuntugis/ppa
      $ sudo apt-get update
      $ sudo apt-get install postgis
      ```
   * imagemagick
     * MacOS: `brew install imagemagick`
     * Linux: `sudo apt-get install imagemagick`

   * ffmpeg
     * MacOS: `brew install ffmpeg`
     * Linux: `sudo apt-get install ffmpeg`

* Configuration
* Database creation
```
$ psql
# create user app with CREATEROLE;
# \q
$ rake db:create
```
* Database initialisation
```
$ rails dbconsole
# CREATE EXTENSION pg_trgm;
# CREATE EXTENSION postgis;
# CREATE EXTENSION postgis_topology;
# \q
$ rake db:migrate
$ ADMIN_PASSWORD=<admin-password> rake db:seed
```

* How to run the test suite
```
$ rake spec
```

* Ask for the `master.key`, you can put the this key under `/opt/skooteo` and then in your skooteo `config` create a symlink to the key.
* Running the app `rails s -p 3030`, then go to http://127.0.0.1:3030

* Deployment instructions
  * Install mina locally `gem install mina`
  * Copy the private/public ssh key from the server and put it your ssh config
  * Adjust your ssh-config so that when mina ssh to the deployment server, the config will be used automatically
  * Run `mina deploy` on the app's folder

# DEPLOYMENT

## MAKE SURE TO INSTALL FFMPEG OTHERWISE ALL VIDEO METADATA ON UPLOAD WILL BE EMPTY!!!!

## Set the following ENV vars

* RAILS_MASTER_KEY
* APP_DATABASE_HOST
* APP_DATABASE_USERNAME
* APP_DATABASE_PASSWORD
* SIDEKIQ_REDIS_HOST
* SIDEKIQ_REDIS_PORT
* FIREBASE_CREDENTIALS - this should point to the location of the `skooteo-firebase.json`

## Setup deploy user account
* create user deploy
* assign user deploy to sudo group
* as a root user, create a file called `skooteo-users` under /etc/sudoers.d with the following contents:
```
Cmnd_Alias SIDEKIQ = /bin/systemctl restart sidekiq, /bin/systemctl stop sidekiq, /bin/systemctl start sidekiq
deploy ALL=NOPASSWD: SIDEKIQ
```

## Sidekiq deployment using systemd

* Generate an rvm wrapper `rvm alias create skooteo ruby-2.5.1`
