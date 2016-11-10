#!/bin/bash
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.16.28
sudo yum install vim -y
