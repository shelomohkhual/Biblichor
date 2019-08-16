# CHAPTER 1: Create Your Server

It's time for us to create our server. Open up AWS and go to the EC2 page.

## Step 1: Choose your operating system

We want to use Ubuntu 18.04 for our server's operating system. It's an long-term support (LTS) release which means it will receive security updates for several more years than normal. This is crucial for production.

Click on Launch Instance and choose `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type` from the Amazon Machine Image list

## Step 2: Choose your size

Go ahead and select the server size. For the free tier, make sure you select the `t2.micro` instance.

Not sure what size to use? Just start with a smaller server. You can always resize the server to a larger size later without losing any data if you want. That's the nice part of these "virtual" servers. They're not real servers, so you easily add more RAM or CPUs to your server at any time.

## Step 3: Configure Security Group

Click on Next until Step 6: Configure Security Group. Add HTTP and HTTPS.

## Step 4: Create your server

Lastly, click "Launch" to create your server. It will take about ~60 seconds for AWS to create your server.

## Step 5: Select Key Pair

If you have an existing key pair, use it if you would like. If you do not have one, choose `Create a new key pair` and name it something you would remember. Download the key pair, then click `Launch Instances`'

After you have downloaded the key pair (pem) file, you will need to chmod it to change it's permissions:

```bash
# Local Machine (At the folder where you have the keypair file)
chmod go= myapp.pem
```

You can login to your server as root (ubuntu) by running the following command, just change `1.2.3.4` to your server's public IP address:

```bash
# Local Machine
ssh -i /path/to/myapp.pem ubuntu@1.2.3.4
```

## Step 6: Creating a Deploy user
To run software on our server, we're going to create a deploy user. The deploy user has limited permissions in production to help prevent anyone from getting full control of our server if a hacker broke into our server.

While logged in as ubuntu on the server, we can run the following commands to create the deploy user and add them to the sudo group.

It will show up like this:
```
~$ sudo adduser deploy
Adding user `deploy' ...
Adding new group `deploy' (1001) ...
Adding new user `deploy' (1001) with group `deploy' ...
The home directory `/home/deploy' already exists.  Not copying from `/etc/skel'.
Changing the user information for deploy
Enter the new value, or press ENTER for the default
    Full Name []: 
    Room Number []: 
    Work Phone []: 
    Home Phone []: 
    Other []: 
Is the information correct? [Y/n] Y
```
You will be asked to type in a password for the user.

Then you want to make the deploy user you just created a superuser.

```bash
# ubuntu@1.2.3.4
sudo adduser deploy sudo
```

Next we will want to copy the authorized_key from the ubuntu user to the deploy user so that we can login with the deploy user. While at it, we also want to add the local machine's key to the server as an authorized_key. You will need to do this for every development machine you have to enable keyless access, otherwise you will have to reference the .pem file to login.

```bash
# Local Machine
cat ~/.ssh/id_*.pub | ssh -i /path/to/myapp.pem ubuntu@1.2.3.4 'cat >> .ssh/authorized_keys'
```
Now you can login as ubuntu without having to type in a password!

Let's do the same with the deploy user.
```bash
# ubuntu@1.2.3.4
cat ~/.ssh/authorized_keys
```
Copy the two lines that appear (They should start with ssh-rsa) using Ctrl+Shift+C (Ubuntu) or Command+C (Mac)

```bash
# ubuntu@1.2.3.4
sudo su - deploy
# deploy@1.2.3.4
nano ~/.ssh/authorized_keys
```
Paste (Ctrl+Shift+V or Command-V) the two lines into this file. Exit and save the file by pressing: `Ctrl+X`, `Shift+Y` and press `Enter` when prompted for the filename.

```bash
# deploy@1.2.3.4
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Double check that the permissions are correct and reset them to what they need to be.

Now, you can either `ssh ubuntu@1.2.3.4` or `ssh deploy@1.2.3.4` without needing a keyfile anymore.

For the rest of this tutorial, we want to be logged in as deploy to setup everything. Let's SSH in as deploy now.

```bash
# Local Machine
ssh deploy@1.2.3.4
```

# CHAPTER 2: Installing Ruby

Installing Ruby in production is similar to development except we need to make sure we have all the Linux dependencies installed to compile Ruby correctly.

We also want to use a Ruby version manager for this so we can easily deploy new versions of Ruby to production in the future without having to edit config files.


## Installing Ruby
We're going to be installing Ruby using a ruby version manager. You're probably using one in development, but this is also handy in production so it allows you to upgrade Ruby version in production quickly.

The first step is to install some dependencies for compiling Ruby as well as some Rails dependencies.

To make sure we have everything necessary for Webpacker support in Rails, we're first going to start by adding the Node.js and Yarn repositories to our system before installing them.

We're also going to install Redis so we can use ActionCable for websockets in production as well. You might also want to configure Redis as your production store for caching.

Make sure you're logged in as the deploy user on the server, and run the following commands:

```bash
# deploy@1.2.3.4
# Adding Node.js 10 repository
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# Adding Yarn repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo add-apt-repository ppa:chris-lea/redis-server
# Refresh our packages list with the new repositories
sudo apt-get update
# Install our dependencies for compiiling Ruby along with Node.js and Yarn
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

Now that we have our dependencies installed, we can begin installing Ruby.

We're going to install Ruby using a Ruby version manager called rbenv. It is the easiest and simplest option, plus it comes with some handy plugins to let us easily manage environment variables in production.

```bash
# deploy@1.2.3.4

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
exec $SHELL
rbenv install 2.6.3
rbenv global 2.6.3
ruby -v
# ruby 2.6.3
```
The last step is to install Bundler:

```bash
# deploy@1.2.3.4
# This installs the latest Bundler, currently 2.0.2.
gem install bundler
# Test and make sure bundler is installed correctly, you should see a version number.
bundle -v
# Bundler version 2.0.2
```
If it tells you bundle not found, run rbenv rehash and try again.

# CHAPTER 3: Configuring A Web Server

Rails won't live on its own in production. In front of Rails, we'll put up NGINX to handle SSL and serving static files because it's way faster than Ruby.

To run our Rails app, we'll install the Passenger module for NGINX to forward requests over to Rails.

## Installing NGINX & Passenger
For production, we'll be using NGINX as our webserver to receive HTTP requests. Those requests will then be handed over to Passenger which will run our Ruby app.

Installing Passenger is pretty straightforward. We'll add their repository and then install and configure their packages.

```bash
# deploy@1.2.3.4
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y nginx-extras libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
sudo ls /etc/nginx/conf.d/mod-http-passenger.conf
```
Now that we have NGINX and Passenger installed, we need to point Passenger to the correct version of Ruby.

We'll start by opening up the Passenger config file in your favorite editor, nano

```bash
# deploy@1.2.3.4
# If you want to use the Nano for editing
sudo nano /etc/nginx/conf.d/mod-http-passenger.conf
```
We want to change the passenger_ruby line to match the following:

```bash
passenger_ruby /home/deploy/.rbenv/shims/ruby;
```
Save this file and we'll start NGINX.

```bash
# deploy@1.2.3.4
sudo service nginx start
```

## Testing your NGINX server

You can check and make sure NGINX is running by visiting your server's public IP address in your browser and you should be greeted with the "Welcome to NGINX" message.

Next we're going to remove this default NGINX server and add one for our application instead.

```bash
# deploy@1.2.3.4
sudo rm /etc/nginx/sites-enabled/default
# If you want to use the Nano for editing
sudo nano /etc/nginx/sites-enabled/myapp
```

We want the contents of our NGINX site to look like the following.

Change `myapp` to the name of your app. We'll use this same folder later on when we define our Capistrano `deploy_to` folder.

```
server {
  listen 80;
  listen [::]:80;

  server_name _;
  root /home/deploy/myapp/current/public;

  passenger_enabled on;
  passenger_app_env production;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
```

Save the file and then we'll reload NGINX to load the new server files.

```bash
# deploy@1.2.3.4
sudo service nginx reload
```

# CHAPTER 4: Creating A Database

For production, we'll need to create a new database for all our production records.

We recommend PostgreSQL for your production database.

Creating a PostgreSQL Database
For Postgres, we're going to start by installing the Postgres server and libpq which will allow us to compile the pg rubygem.

Then, we're going to become the postgres linux user who has full access to the database and use that account to create a new database user for our apps. We'll call that user deploy.

And finally, the last command will create a database called `myapp` and make the deploy user `owner`.

Make sure to change `myapp` to the name of your application.

```bash
# deploy@1.2.3.4
sudo apt-get install postgresql postgresql-contrib libpq-dev
sudo su - postgres
createuser --pwprompt deploy
createdb -O deploy myapp
exit
```

## Testing your SQL

You can manually connect to your database anytime by running `psql -U deploy -W -h 127.0.0.1 -d myapp`. Make sure to use 127.0.0.1 when connecting to the database instead of localhost.

To exit from PSQL, use:
```sql
\q
```

# CHAPTER 5: Deploying Code

Once we have everything on our server configured and ready to go, we need a way to upload our code to production.

Capistrano is a tool for making copies of your repository in production and then easily making new releases.

## Setting Up Capistrano

Back on our local machine, we can install Capistrano in our Rails app.

We'll need to add the following gems to our Gemfile:

```ruby
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-passenger'
gem 'capistrano-rbenv'
```

Once added, we can run the following to install the gems and have Capistrano install its config files:

```bash
# Local Machine
bundle install
bundle exec cap install STAGES=production
```

This generates several files for us:

```
Capfile
config/deploy.rb
config/deploy/production.rb
```

We're need to edit the Capfile and add the following lines:

```ruby
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rbenv'

set :rbenv_type, :user
set :rbenv_ruby, '2.6.3'
```

Then we can modify config/deploy.rb to define our application and git repo details. Again, please change `myapp` to your own app name, and edit the `repo_url` before copying

```
set :application, "myapp"
set :repo_url, "git@github.com:username/myapp.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

```

Now we need to modify config/deploy/production.rb to point to our server's IP address for production deployments. Make sure to replace 1.2.3.4 with your server's public IP.

```ruby
server '1.2.3.4', user: 'deploy', roles: %w{app db web}
```

Before we can deploy our app to production, we need to SSH into the server one last time and add our environment variables.

```bash
# Local Machine
ssh deploy@1.2.3.4
mkdir /home/deploy/myapp
nano /home/deploy/myapp/.rbenv-vars
```
Add any environment variables you need for production to this file.

Please do not copy blindly - edit the `PASSWORD` and `myapp` in the DATABASE_URL to your own password you set earlier when you set up the Database.

```ruby
# For Postgres
DATABASE_URL=postgresql://deploy:PASSWORD@127.0.0.1/myapp
RAILS_MASTER_KEY=ohai
SECRET_KEY_BASE=1234567890
# etc...
```

Save this file and these environment variables will be automatically loaded every time you run Ruby commands inside your app's directory on the server.

Using this method, we can have separate env variables for every application we deploy to this server.

Now we can deploy our app to production:

```bash
# Local Machine
bundle exec cap production deploy
```
Open your server's IP in your browser and you should be greeted with your Rails application.


## Viewing the Server Logs
If you see an error, you can SSH into the server and view the log files to see what's wrong.

```bash
# deploy@1.2.3.4
# To view the Rails logs
nano /home/deploy/myapp/current/log/production.log
# To view the NGINX and Passenger logs
sudo nano /var/log/nginx/error.log
```
Once you find your error (often times a missing environment variable or config for production), you can fix it and restart or redeploy your app.

# CHAPTER 6: Congratulations!

Congratulations! You've deployed your app to production.

# POST: Additional Steps

Now you would need to configure SSL and your domain on production.

## Domain Configuration

Add your domain name to server_name in your `/etc/nginx/sites-enabled/myapp` file:

```
server {
  ...

  server_name example.com;

  ...
}
```

Save the file and then we'll reload NGINX to load the new server files.

## SSL Configuration

Use [Certbot / Lets Encrypt](https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx) to enable SSL for your site

## Installing Sidekiq

For this, we will enlist the help of a capistrano plugin

```ruby
gem 'capistrano-sidekiq'
```

Once added, we can run the following to install the gem:

```bash
# Local Machine
bundle install
```

We're need to edit the Capfile and add the following line at the bottom:

```ruby
require 'capistrano/sidekiq'
```

Then we can modify config/deploy.rb to add some settings:

```
set :pty, false
set :init_system, :systemd
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :bundler_path, "/home/deploy/.rbenv/shims/bundler"
```

You will also need to ssh into the server and use this command (assuming `deploy` is your username on Ubuntu server):

```bash
# deploy@1.2.3.4
loginctl enable-linger deploy
```

You will also need to add an environment variable to your `.rbenv-vars`
```bash
nano ~/myapp/.rbenv-vars
```
and add:
```bash
REDIS_URL=redis://localhost:6379
```

Finally, run this command:
```bash
# Local Computer
bundle exec cap sidekiq:install
```

Sidekiq should be installed and will be restarted upon every deploy.

## Installing an Error Monitoring Service

Sign Up for [Honeybadger](https://www.honeybadger.io/) - Go to pricing, then choose Solo Plan. Set it up as per the instructions.

## Setting up Elasticsearch

Go to your AWS Console. Choose `Amazon Elasticsearch Service` under Services.

1. Choose Deployment Type: Development and Testing
2. Elasticsearch version: 7.1
3. Elasticsearch domain name: Any name you prefer
4. Instance type: **t2.small.elasticsearch**
5. Number of instances: **1**
6. Choose VPC Access
7. Under VPC, choose your VPC, Subnet and Security Group based on your EC2's VPC, Subnet and Security Group
8. Set the domain access policy to: Do not require signing request with IAM Credentials

Click confirm. After the Elasticsearch has provisioned (About 10 minutes) you will find the URL you will need below under VPC Endpoint. You will need to slightly modify this - add a `:443` at the end for the URL below.

For your Searchkick to connect to ElasticSearch you will need to add this file.

Create an initializer `config/initializers/elasticsearch.rb` with:

```ruby
ENV["ELASTICSEARCH_URL"] = "https://vpc-recode-u4of3mgs3ov72peb7aw5r5c7s4.us-east-1.es.amazonaws.com:443"
```