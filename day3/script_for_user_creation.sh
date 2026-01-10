#!/bin/bash


create_user() {
   read -p "Enter username: " USERNAME

    # -m creates the home directory automatically
    # -s /bin/bash ensures they get a nice colorful prompt, not just a '$'
    sudo useradd -m -s /bin/bash "$USERNAME"

    # Set the password
    echo "$USERNAME:Password@123" | sudo chpasswd

    echo " User $USERNAME created with Home Directory and Bash shell."
}

create_user
