#!/bin/bash

# WARNING: This command will delete all files and directories in the current location.
# Uncomment the following line only if you intend to clear the current directory.
# sudo rm -r *

# Move the 'env' directory to '.env' if needed (rename for convention purposes).
# Uncomment if you need to rename an existing virtual environment directory.
# sudo mv env .env

# Update package lists for upgrades and new package installations
sudo apt-get update

# Optional: Install Python virtual environment tools (uncomment if needed)
# sudo apt-get install python3-venv

# Check if the 'env' directory already exists before creating a new virtual environment
if [ ! -d "env" ]; then
    # Create a new virtual environment in the 'env' directory
    python3 -m venv env
fi

# Activate the virtual environment
source env/bin/activate

# Install all required packages listed in 'requirements.txt'
pip install -r requirements.txt

# Install Gunicorn, the WSGI server, if it's not listed in requirements.txt
pip install gunicorn

# Make database migrations (prepares migration files)
python manage.py makemigrations

# Apply the migrations to the database
python manage.py migrate

# Start the Django development server (for local development/testing only)
# Uncomment the next line if you want to run the Django development server
# python manage.py runserver 0.0.0.0:8000

# Start the application with Gunicorn for production
# This will start Gunicorn with 3 worker processes, listening on all interfaces at port 8000
gunicorn --workers 3 --bind 0.0.0.0:8000 pilixar.wsgi:application


