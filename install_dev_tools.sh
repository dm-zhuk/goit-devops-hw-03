#!/bin/bash

# Common check if command exists
check_install() {
    if command -v "$1" &> /dev/null;
    then
        echo "$1 is already installed."
        return 0
    else
        echo "$1 not found. Installing..."
        return 1
    fi
}

# 1. Update package list
sudo apt-get update

# 2. Install Docker
if ! check_install docker;
then
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    # Add user to group (effect takes place after logout/login)
    sudo usermod -aG docker "$USER"
    echo "! You may need to log out and back in for docker permissions to update."
fi

# 3. Install Docker Compose
if ! check_install docker-compose;
then
    sudo apt-get install -y docker-compose
fi

# 4. Install Python 3.9+
if ! check_install python3;
then
    sudo apt-get install -y python3
fi

# Version verification logic
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
# Compare versions
if [[ $(echo "$PYTHON_VERSION < 3.9" | bc -l 2>/dev/null) -eq 1 ]];
then
    echo "Python version is $PYTHON_VERSION. Updating to a newer version is recommended."
else
    echo "Python version $PYTHON_VERSION meets the 3.9+ requirement."
fi

# 5. Install Pip and Django
if ! check_install pip3;
then
    sudo apt-get install -y python3-pip
fi

if ! python3 -m django --version &> /dev/null;
then
    echo "Django not found. Installing..."
    pip3 install django
else
    echo "Django $(python3 -m django --version) is already installed."
fi

echo "🟢 Success: all tools installed, setup complete!"

# chmod u+x install_dev_tools.sh
# to install development tools:
# ./install_dev_tools.sh

# git checkout -b lesson-3
# git add install_dev_tools.sh
# git commit -m "Add Bash script for installing Docker, Docker Compose, Python, and Django"
# git push origin lesson-3