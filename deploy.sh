# #!/bin/bash

# # WARNING: This command will delete all files and directories in the current location.
# # Uncomment the following line only if you intend to clear the current directory.
# #sudo rm -r *

# # Move the 'env' directory to '.env' if needed (rename for convention purposes).
# # Uncomment if you need to rename an existing virtual environment directory.

#sudo systemctl stop gunicorn.service

# sudo mv env .env
# # Update package lists for upgrades and new package installations
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa


# sudo apt-get install  python3.11 
# sudo apt-get install python3.11-venv 
# sudo apt-get install python3-pip 
# sudo apt-get install  nginx

# python3.11  -m venv box_venv

sudo apt-get -y install python3.11 python3.11-venv python3-pip nginx


python3.11 -m venv box_venv

# # Activate the virtual environment
source box_venv/bin/activate

# # Install all required packages listed in 'requirements.txt'
pip install -r requirements.txt


cp env .env
# # Install Gunicorn, the WSGI server, if it's not listed in requirements.txt

# # Make database migrations (prepares migration files)



python3.11 manage.py add_product

# Reload systemd manager configuration
sudo systemctl daemon-reload

if sudo journalctl -xe | grep -q "systemd[1]: Reloading"; then
    echo "Systemctl daemon successfully reloaded."
else
    echo "Systemctl daemon reload failed. Check systemd logs for more information."
    exit 1
fi

# Stop Gunicorn service if it's running
sudo systemctl stop gunicorn.service

# Remove the existing Gunicorn service file, if it exists
if [ -f /etc/systemd/system/gunicorn.service ]; then
    sudo rm /etc/systemd/system/gunicorn.service
fi




# Copy the new Gunicorn service file to the systemd directory
sudo cp gunicorn.service /etc/systemd/system/gunicorn.service


sudo systemctl daemon-reload

if sudo journalctl -xe | grep -q "systemd[1]: Reloading"; then
    echo "Systemctl daemon successfully reloaded."
else
    echo "Systemctl daemon reload failed. Check systemd logs for more information."
    exit 1
fi

# Start the Gunicorn service
sudo systemctl start gunicorn.service

# Check the status of the Gunicorn service
sudo systemctl status gunicorn.service

# Remove the existing Nginx configuration, if it exists
if [ -f /etc/nginx/sites-available/pixilar_config ]; then
    sudo rm /etc/nginx/sites-available/pixilar_config
fi

if [ -f /etc/nginx/sites-enabled/pixilar_config ]; then
    sudo rm /etc/nginx/sites-enabled/pixilar_config
fi

# Copy the new Nginx configuration to the available sites directory
sudo cp pixilar_config /etc/nginx/sites-available/

# Create a symbolic link in the sites-enabled directory
sudo ln -s /etc/nginx/sites-available/pixilar_config /etc/nginx/sites-enabled/

# Reload the Nginx configuration
sudo systemctl reload nginx

# Check the logs for the Gunicorn service
sudo journalctl -u gunicorn.service
