#!/usr/bin/env bash

VALIDATE='\033[1;32m'
COLOR='\033[1;34m'
NC='\033[0m' # No Color


function menu {
# L'utilisateur choisit le package qu'il souhaite installer
    optionsPkg=("Apache 2" "PHP 7" "My SQL Server" "J'ai terminé l'installation") 
    sleep 1
    echo -e "${COLOR}Choisissez un package à installer sur votre VM : ${NC}"
    select responsePkg in "${optionsPkg[@]}";do
        case ${responsePkg} in
            "Apache 2" ) pkgChoice="apache2";break;;
            "PHP 7" ) pkgChoice="php7";break;;
            "My SQL Server" ) pkgChoice="mysqlserver";break;;
            "J'ai terminé l'installation" ) pkgChoice="quit";break;;
        esac
     done
     
    # APACHE 2
    if [ "$pkgChoice" == "apache2" ]
        then
            echo -e "${COLOR}Installation de Apache 2 ${NC}"
            sleep 2
            sudo apt-get -y install apache2
            sleep 1 
            menu
    fi
    
    # PHP 7
    if [ "$pkgChoice" == "php7" ]
        then
            echo -e "${COLOR}Installation de PHP 7 ${NC}"
            sleep 2
            sudo apt-get -y install php7.0
            sudo apt-get -y install php7.0-mysql
            sudo apt-get -y install libapache2-mod-php7.0
            menu
    fi
    
    # MY SQL SERVER
    if [ "$pkgChoice" == "mysqlserver" ]
        then
            echo -e "${COLOR}Installation de My SQL Server ${NC}"
            sleep 1
            read -sp "Choisissez un mot de passe :" mdpSql
            sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mdpSql"
            sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mdpSql"
            sudo apt-get -y install mysql-server
            sleep 1
            menu
    fi
    
    # QUIT
    if [ "$pkgChoice" == "quit" ]
        then
          echo -e "${COLOR}Installation des packages terminée${NC}"
          echo -e "${VALIDATE}Votre Vagrant est désormais fonctionnelle.${NC}"
          echo -e "${VALIDATE}Vous pouvez y accéder à l'IP suivante : 192.168.33.10 ${NC}"
          exit
    fi
    
     
}






echo -e "${COLOR}Bienvenue dans la deuxième partie de l'installation de votre VM${NC}"
menu
