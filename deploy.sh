#!/bin/bash




echo "deleting old app"
sudo rm -rf /var/www/

echo "creating app folder"
sudo mkdir -p /var/www/pixilar

echo "moving files to app folder"
sudo mv  * /var/www/pixilar

# Navigate to the app directory
cd /var/www/pixilar/
sudo mv env .env

sudo apt-get update


