#!/bin/bash
# Update the instance packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Git (to clone the app repository)
sudo apt-get install -y git

# Install Node.js (and npm)
sudo apt-get install -y nodejs npm

# Check the installed versions of Node.js and npm
node -v
npm -v

# Clone the Node.js app from your GitHub repository (replace with your actual repo URL)
git clone https://github.com/getdzidon/jomacs-q1.git

# Navigate to the app directory
cd jomacs-q1

# Install the required dependencies from package.json
npm install

# Start the Node.js application (using pm2 for production, or simply npm start for development)
npm start


# For a static website or a PHP-based application, you might want to use a web server like Nginx or Apache instead of Node.js. 
# However, for a Node.js application, especially if it's a dynamic app or API, you don’t need Nginx or Apache unless you're using 
# them for reverse proxying (which is common but not necessary in every case).