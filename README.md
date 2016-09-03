# cloud_monitor_server
AWS-SDK(Ruby) integration and REST APIs to access AWS services

- *Please go through details provided below to Setup this app* 
- *After that please check my another app [cloud_monitor_agent](https://github.com/rutisyrz/cloud_monitor_agent) to check integration of REST APIs of this app*


## Technology stack
- AWS( EC2, CloudWatch-*Custom Metrics*, CloudWatch-*Default Metrics*, IAM ), Ruby 2.1.2, Rails 4.1, RVM, MongoDB

## Required Gems
- [aws-sdk](https://rubygems.org/gems/aws-sdk), [mongoid](https://rubygems.org/gems/mongoid), [bson_ext](https://rubygems.org/gems/bson_ext), [figaro](https://rubygems.org/gems/figaro)

## Prerequisite
- AWS (free tier) account
- Create a user using IAM dashboard
  - Ensure user has access to EC2 & CloudWatch services
  - Download user credentials
- Launch an EC2 instance (OS - Ubuntu 14.04)
- Configure *CloudWatch Custom Metrics* on server
  - [Click here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/mon-scripts.html)
  - **Note:** If you create an AMI from an instance that already had Custom Metrics configured, any instances launched from this AMI within the cache TTL (default: six hours, 24 hours for Auto Scaling groups) will emit metrics using the original instance's ID. 
  After the cache TTL time period passes, the script will retrieve fresh data and the scripts will use the current instance's ID. To immediately correct this, remove the cached data using: 
```shell
$ rm /var/tmp/aws-mon/instance-id.
```

## What is CloudWatch Custom Metrics?
- AWS CloudWatch does not provide these Metrics - *Disk Space Utilization (%)*, *Disk Space Used (GB)*, *Disk Space Available (GB)*, *Memory Utilization (%)*, *Memmory Used (MB)*, *Memmory Available (MB)*, *Swap Utilization (%)*, *Swap Used (MB)*
- To populate the same for detailed monitoring of EC2 servers, AWS provides a Monitoring script (written in Perl) to produce custom metrics for EC2 Linux based instances.
- Custom metrics, once populated by script, can be found under **Linux System** section on *CloudWatch* dashboard
- AWS CloudWatch Custom Metrics pricing - [click here](https://aws.amazon.com/cloudwatch/pricing/)

## Setup code

- Install bundle
```ruby
$ bundle install
```
- Install MongoDB on Mac OS
```shell
$ brew install mongodb
```
- Install MongoDB on Ubuntu
```shell
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
$ sudo echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
$ sudo apt-get -y update
$ sudo apt-get install mongodb-org
```
- Verify MongoDB installation 
```shell
$ mongod --version
```
- Check status of MongoDB
```shell
$ service mongod status
```
- **Note:** By default starts running after installation on port=27017 *http://localhost:27017/*
- Start/Stop MongoDB
```shell
$ sudo service mongod start
$ sudo service mongod stop
```
- Run rails app on port=4000
```ruby
$ rails s -p 4000
```

## How to use this app?

- Register your IAM user as an *Agent* at */agents*
- You need to use **server_access_token** to access REST APIs designed in this App to access EC2 & CloudWatch services
- Now, switch to another app [cloud_monitor_agent](https://github.com/rutisyrz/cloud_monitor_agent) to check integration of REST APIs of this app

