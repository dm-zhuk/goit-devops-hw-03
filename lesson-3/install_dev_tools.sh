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
    # Add $user to group
    sudo usermod -aG docker "$USER"
    echo "Update docker permissions: log out/log in."
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

# Compare versions
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if [[ $(echo "$PYTHON_VERSION < 3.9" | bc -l 2>/dev/null) -eq 1 ]];
then
    echo "Python version is $PYTHON_VERSION. Updating to a newer version is recommended."
else
    echo "Python version $PYTHON_VERSION meets the 3.9+ requirement."
fi

# 5. Install Pip, Django
if ! check_install pip3;
then
    sudo apt-get install -y python3-pip
fi

if ! python3 -m django --version &> /dev/null;
then
    echo "Django not found. Installing..."
    pip3 install django --break-system-packages
else
    echo "Django $(python3 -m django --version) is already installed."
fi

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
    export PATH="$PATH:$HOME/.local/bin"
fi

echo "🟢 Success: all tools installed, setup complete!"


# source ~/.bashrc
# chmod u+x install_dev_tools.sh
# ./install_dev_tools.sh