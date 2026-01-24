#!/bin/bash
set -e

APP_NAME="brijesh-fitness"
REPO_URL="https://github.com/maliVishal01/Brijesh-s-Fitness.git"
PROJECT_DIR="Brijesh-s-Fitness"
PORT=8000

echo " Django Gym Project Deployment Started"

######################################
# INSTALL DEPENDENCIES
######################################
install_dependencies() {
    echo " Installing Docker & Git..."
    sudo apt update -y
    sudo apt install -y docker.io git
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo chown $USER /var/run/docker.sock || true
}

######################################
# CHECK OLD CONTAINER
######################################
check_old_container() {
    if docker ps -a --format '{{.Names}}' | grep -q "^$APP_NAME$"; then
        echo ""
        echo " Old deployment found!"
        echo "1️  Use OLD container"
        echo "2️  Deploy NEW version (stop old)"
        read -p "Choose (1 or 2): " choice

        if [ "$choice" == "1" ]; then
            echo " Starting old container..."
            docker start $APP_NAME
            echo " Open: http://<SERVER_PUBLIC_IP>:${PORT}"
            exit 0
        elif [ "$choice" == "2" ]; then
            echo " Stopping old container..."
            docker rm -f $APP_NAME
        else
            echo " Invalid choice"
            exit 1
        fi
    fi
}

######################################
# CLONE OR UPDATE PROJECT
######################################
clone_project() {
    if [ -d "$PROJECT_DIR" ]; then
        echo " Updating existing project..."
        cd $PROJECT_DIR
        git pull
    else
        echo " Cloning project..."
        git clone $REPO_URL
        cd $PROJECT_DIR
    fi
}

######################################
# BUILD IMAGE
######################################
build_image() {
    echo " Building Docker image..."
    docker build -t $APP_NAME .
}

######################################
# RUN CONTAINER
######################################
run_container() {
    echo " Running Docker container..."
    docker run -d \
        --name $APP_NAME \
        -p $PORT:8000 \
        --restart always \
        $APP_NAME
}

######################################
# MAIN FLOW (VERY CLEAR)
######################################
install_dependencies
check_old_container
clone_project
build_image
run_container

echo " Deployment Completed"
echo " Open in browser: http://<SERVER_PUBLIC_IP>:${PORT}"
