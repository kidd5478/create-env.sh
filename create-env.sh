#!/bin/bash

#!aws ec2 run-instances --image-id ami-06b94666 --key-name inclass --security-group-ids sg-c5ff2abc --instance-type t2.micro --count 3 --user-data file://installenv.sh --placement Availabilityzone=us-west-2a

aws autoscaling create-launch-configuration --launch-configuration-name webserver --image-id ami-06b94666 --key-name inclass  --instance-type t2.micro --user-data file://installenv.sh

aws elb create-load-balancer --load-balancer-name itmo-444-mk --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnets subnet-a57849c1 subnet-0f951957 subnet-12a2eb64

aws autoscaling create-auto-scaling-group --auto-scaling-group-name webserverdemo --launch-configuration webserver --availability-zone us-west-2a --load-balancer-names itmo-444-mk --max-size 5 --min-size 1 --desired-capacity 3

ID=`aws ec2 describe-instances --query 'Reservations[*].Instances[].InstanceId'`

aws elb register-instances-with-load-balancer --load-balancer-name itmo-444-mk --instances $ID
