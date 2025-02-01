#!/bin/bash
# Update the instance packages
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git
sudo apt-get install -y nodejs npm # Install Node.js (and npm)
# Check the installed versions of Node.js and npm
node -v
npm -v
git clone https://github.com/getdzidon/jomacs-q1.git # Clone the Node.js app from your GitHub repository 
cd jomacs-q1 # Navigate to the app directory
npm install # Install the required dependencies from package.json
npm start # Start the Node.js application (using pm2 for production, or simply npm start for development)


# For a static website or a PHP-based application, you might want to use a web server like Nginx or Apache instead of Node.js. 
# However, for a Node.js application, especially if it's a dynamic app or API, you don’t need Nginx or Apache unless you're using 
# them for reverse proxying (which is common but not necessary in every case).


#Already used the following app-deploy.yml file to deploy the app on AWS EC2 instance
# Or use nginx as reverse proxy server for nodejs app
# sudo apt-get install -y update
# sudo apt-get install -y upgrade
# sudo apt-get install -y nginx
# sudo systemctl start daemon-reload
# sudo systemctl start nginx
# sudo systemctl enable nginx