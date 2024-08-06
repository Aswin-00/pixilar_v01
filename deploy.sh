#!/bin/bash

# WARNING: This command will delete all files and directories in the current location.
# Uncomment the following line only if you intend to clear the current directory.
#sudo rm -r *

# Move the 'env' directory to '.env' if needed (rename for convention purposes).
# Uncomment if you need to rename an existing virtual environment directory.
sudo mv env .env
# Update package lists for upgrades and new package installations
sudo apt-get update
sudo apt-get  install python3.11
sudo apt-get -y install python3.11-venv  python3.11-full

# Check if the 'env' directory already exists before creating a new virtual environment
    # Create a new virtual environment in the 'env' directory
python3.11  -m venv box_venv


# Activate the virtual environment
source box_venv/bin/activate

# Install all required packages listed in 'requirements.txt'
pip install -r requirements.txt

# Install Gunicorn, the WSGI server, if it's not listed in requirements.txt
pip install gunicorn

# Make database migrations (prepares migration files)
python3.11 manage.py makemigrations

# Apply the migrations to the database
python3.11 manage.py migrate

# Start the Django development server (for local development/testing only)
# Uncomment the next line if you want to run the Django development server
#python manage.py runserver 0.0.0.0:8000

# Start the application with Gunicorn for production
# This will start Gunicorn with 3 worker processes, listening on all interfaces at port 8000
#gunicorn --workers 3 --bind 0.0.0.0:8000 pilixar.wsgi:application
nohup gunicorn pilixar.wsgi:application --bind 0.0.0.0:8000 --workers 3 &

