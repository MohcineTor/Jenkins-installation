#!/bin/bash

echo "Welcome to the Jenkins installation script."


echo "

                     **                  **     **                 
                    /**                 /**    //                  
                    /**  *****  ******* /**  ** ** *******   ******
                    /** **///**//**///**/** ** /**//**///** **//// 
                    /**/******* /**  /**/****  /** /**  /**//***** 
                **  /**/**////  /**  /**/**/** /** /**  /** /////**
                //***** //****** ***  /**/**//**/** ***  /** ****** 
                /////   ////// ///   // //  // // ///   // //////  

"
echo "╔══════════════════════════════════════════╗"
echo "║  :Please choose the installation method: ║"
echo "╠══════════════════════════════════════════╣"
echo "║                                          ║"
echo "║                                          ║"
echo "║       1. Docker container                ║"
echo "║       2. Direct installation on the OS   ║"
echo "║                                          ║"
echo "║                                          ║"
echo "╚══════════════════════════════════════════╝"    
read -p "Enter your choice (1 or 2): " choice

if [[ $choice == 1 ]]; then
    echo "========> You have chosen to install Jenkins as a Docker container."
    # Add the Docker installation commands here
    docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
    # Get the Jenkins container ID
    jenkins_container_id=$(docker ps -f "ancestor=jenkins/jenkins:lts" -q)
    # Print the Jenkins container ID
    echo "========> Jenkins container ID: $jenkins_container_id"   
    # Access the container and retrieve the initial admin password
    echo "========> Access the container:"
    docker exec -it $jenkins_container_id cat /var/jenkins_home/secrets/initialAdminPassword

elif [[ $choice == 2 ]]; then
    echo "========> You have chosen to install Jenkins directly on the server."
    read -p "Choose your operating system, e.g., Arch Linux, Ubuntu: " os 
    if [[ $os == "ArchLinux" ]]; then 
        echo "========> You have chosen $os as the operating system. Good luck!"
        # Add the direct installation commands here
        sudo pacman -Syu
        sudo pacman -Sy jenkins
        sudo pacman -Sy vim jre17-openjdk
        archlinux-java status 
        sudo archlinux-java set java-17-openjdk
        archlinux-java get
        archlinux-java status
        sudo vim /etc/conf.d/jenkins
        sudo systemctl daemon-reload
        sudo systemctl restart jenkins
        sudo systemctl enable jenkins
        sudo systemctl status jenkins
        echo "========> Default administrator password:"
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    elif [[ $os == "Ubuntu" ]]; then
        echo "========> You have chosen $os as the operating system. Good luck!"
        sudo apt update
        sudo apt install openjdk-17-jre -y 
        java -version
        curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
        echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
        sudo apt-get update
        sudo apt-get install jenkins
        sudo systemctl enable jenkins
        sudo systemctl start jenkins
        sudo systemctl status jenkins
        sudo ufw allow 8080
        sudo ufw allow OpenSSH
        sudo ufw enable
        sudo ufw status
        echo "========> Default administrator password:"
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    else
        echo "========> Invalid operating system choice. Please try again."
    fi 
else
    echo "========> Invalid choice. Please try again."
fi

echo "
   _   _   _   _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \ 
 ( J | e | n | k | i | n | s )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
"
echo "Script written by Mohcine TOR."
