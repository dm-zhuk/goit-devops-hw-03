# Django GOIT Project
This repository contains a containerized Django application integrated with a PostgreSQL database and an Nginx reverse proxy. The environment is designed to be developed on macOS (using VS Code) and executed within a Multipass Ubuntu VM.

## System Architecture

Web Server: Nginx (Proxying requests to Django)

Application: Django (Python 3.10-slim)

Database: PostgreSQL 15

Virtualization: Multipass (Ubuntu 24.04 LTS)

Containerization: Docker & Docker Compose

## Project Structure

├── django-goit
│   ├── core                # Django project settings
│   │   ├── __init__.py
│   │   ├── asgi.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── nginx
│   │   └── nginx.conf      # Nginx configuration
│   ├── Dockerfile          # Django image build instructions
│   ├── docker-compose.yaml # Service orchestration defined for db, django, and nginx
│   └── requirements.txt    # Python dependencies
│   ├── manage.py           # Django management CLI
└── venv/

## Getting Started
1. VM Preparation (macOS Terminal)
Mount the local project directory to your Multipass VM:

Bash
multipass mount ~/path/to/goit-devops-hw-03/django-goit docker-vm:/home/ubuntu/django-goit

2. Launching the Services (inside Multipass)
Connect to your VM and start the containers:

Bash
multipass shell docker-vm
cd ~/django-goit
sudo docker-compose up -d --build

3. Database Initialization
Once the containers are running, apply the migrations to set up the PostgreSQL tables:

Bash
sudo docker-compose exec django python manage.py migrate

4. This stops and removes all containers, networks, and images defined in your yaml:

Bash
docker-compose down