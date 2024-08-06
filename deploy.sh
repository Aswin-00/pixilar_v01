# #!/bin/bash

# # WARNING: This command will delete all files and directories in the current location.
# # Uncomment the following line only if you intend to clear the current directory.
# #sudo rm -r *

# # Move the 'env' directory to '.env' if needed (rename for convention purposes).
# # Uncomment if you need to rename an existing virtual environment directory.

# #sudo systemctl stop gunicorn.service

# sudo mv env .env
# # Update package lists for upgrades and new package installations
# sudo apt-get update
# sudo apt-get -y install python3.11 python3.11-venv  python3.11-full

# python3.11  -m venv box_venv


# # Activate the virtual environment
# source box_venv/bin/activate

# # Install all required packages listed in 'requirements.txt'
# pip install -r requirements.txt

# # Install Gunicorn, the WSGI server, if it's not listed in requirements.txt

# # Make database migrations (prepares migration files)

# python3.11 manage.py add_product

sudo systemctl daemon-reload

sudo  cp gunicorn.service /etc/systemd/system/gunicorn.service


sudo systemctl start gunicorn.service

sudo journalctl -u my_service.service
