#!/bin/bash
set -e

APP_NAME="brijesh-fitness"
REPO_URL="https://github.com/maliVishal01/Brijesh-s-Fitness.git"
PORT=8000

echo " Django Gym Project Deployment Started"

install_dependencies() {
    echo " Installing Docker & Git..."
    sudo apt update -y
    sudo apt install -y docker.io git
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
}

clone_project() {
    cd ~/ShellScript_DevOps/deploy
    if [ -d "Brijesh-s-Fitness" ]; then
        echo "Updating existing project..."
        cd Brijesh-s-Fitness
        git pull
    else
        echo " Cloning project..."
        git clone $REPO_URL
        cd Brijesh-s-Fitness
    fi
}

build_image() {
    echo " Building Docker image..."
    docker build -t $APP_NAME .
}

run_container() {
    echo "▶️ Running Docker container..."
    docker rm -f $APP_NAME || true
    docker run -d \
        --name $APP_NAME \
        -p $PORT:8000 \
        $APP_NAME
}

install_dependencies
clone_project
build_image
run_container

echo " Deployment Completed"
echo " Open in browser: http://<AWS_PUBLIC_IP>:8000"

