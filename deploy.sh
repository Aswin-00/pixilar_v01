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
echo "installing python and pip"
sudo apt-get install -y python3 python3-pip

# Install application dependencies from requirements.txt
echo "Install application dependencies from requirements.txt"
sudo pip install -r requirements.txt


# Create and apply migrations
python manage.py makemigrations
python manage.py migrate


# Update and install Nginx if not already installed
if ! command -v nginx > /dev/null; then
    echo "Installing Nginx"
    sudo apt-get update
    sudo apt-get install -y nginx
fi


# Configure Nginx to act as a reverse proxy
if [ ! -f /etc/nginx/sites-available/myapp ]; then
    sudo rm -f /etc/nginx/sites-enabled/default
    sudo bash -c 'cat > /etc/nginx/sites-available/myapp <<EOF
server {
    listen 80;
    server_name _;

    location / {
        include proxy_params;
        proxy_pass http://unix:/var/www/my-django-app/myapp.sock;
    }
}
EOF'

    sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled
    sudo systemctl restart nginx
else
    echo "Nginx reverse proxy configuration already exists."
fi

# Stop any existing Gunicorn process
sudo pkill gunicorn
sudo rm -rf myapp.sock

# Start Gunicorn with the Django application
echo "starting gunicorn"
sudo gunicorn --workers 3 --bind unix:myapp.sock pilixar.wsgi:application --user www-data --group www-data --daemon
echo "started gunicorn 🚀"


