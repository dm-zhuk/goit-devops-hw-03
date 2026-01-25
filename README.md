# Django GOIT DevOps Project

This repository contains a professional, containerized Django application integrated with a PostgreSQL database and an Nginx reverse proxy. The environment is optimized for a hybrid workflow: developed on **macOS** (VS Code) and executed within a **Multipass Ubuntu VM**.

## System Architecture

* **Reverse Proxy:** Nginx (1.25-alpine) serving static files and proxying requests.
* **Application:** Django (Python 3.10-slim) running via **Gunicorn** for production stability.
* **Database:** PostgreSQL 15 with persistent volume storage.
* **Infrastucture:** Multipass (Ubuntu 24.04 LTS) providing a native Linux environment for Docker.


## Getting Started

1. VM Preparation (macOS Terminal)Mount your local project directory to your Multipass VM to enable real-time code syncing between your Mac and the Linux environment:

#Replace ~/path/to/... with your actual local path
multipass mount ~/path/to/django-goit docker-vm:/home/ubuntu/django-goit

2. Environment SetupCreate your local environment file from the template:

cp .env.example .env

Note: Ensure DEBUG=True for local development and DEBUG=False for production testing.

3. Launching the Services (Inside Multipass)Connect to VM and navigate to the project folder:

multipass shell docker-vm

cd ~/django-goit

### Option A: Development Mode (Fast Coding)
Standard mode with Django's auto-reload server and detailed error pages:

sudo docker-compose up --build

### Option B: Production Mode (Gunicorn + Nginx)
Testing the full stack as it will run in AWS EKS:

sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build


## Maintenance & Commands

Create Admin
sudo docker-compose exec django python manage.py createsuperuser

Collect Static
docker-compose exec django python manage.py collectstatic --noinput

Stop All
docker-compose down

Clean Wipe
docker-compose down -v (Warning: Deletes Database data)


## Project Structure

```text
├── django-goit/
│   ├── .env                  # Local secrets (.gitignore handle)
│   ├── .env.example          # Template for environment variables
│   ├── Dockerfile            # Multi-layer optimized Django image
│   ├── docker-compose.yaml   # Base service definitions (DB & App)
│   ├── docker-compose.override.yml # Local Dev settings (Auto-reload)
│   ├── docker-compose.prod.yaml     # Production settings (Nginx + Gunicorn)
│   ├── entrypoint.sh         # Auto-migrations & static file collection
│   ├── requirements.txt      # Python dependencies
│   ├── core/                 # Django project settings (settings.py)
│   └── nginx/
│       └── nginx.conf        # Nginx reverse proxy configuration