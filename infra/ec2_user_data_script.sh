#!/bin/bash
# Update the instance packages
sudo apt-get install -y update
sudo apt-get install -y upgrade
sudo apt-get install -y nginx
sudo systemctl start daemon-reload
sudo systemctl start nginx
sudo systemctl enable nginx