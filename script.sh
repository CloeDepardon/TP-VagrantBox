#!/usr/bin/env bash

VALIDATE='\033[1;32m'
RED='\033[0;31m'
COLOR='\033[1;34m'
NC='\033[0m'  #NOCOLOR


function vagrantConfig {
    # L'utilisateur donne les noms du dossier principal et du dossier de synchronisation
    sleep 1
    read -p "Choisissez un nom pour le dossier qui accueillera votre vagrant :" nomVagrant
    sleep 1
    read -p "Choisissez un nom pour le dossier de synchonisation de votre Vagrant :" nomSync
    
    # L'utilisateur indique le nom de domaine qu'il utilisera par la suite
    # sleep 1
    # read -p "Choisissez un nom de domaine :" nomDomaine


    # L'utilisateur choisit la box qu'il souhaite utiliser
    optionsBox=("Ubuntu Xenial 64" "Ubuntu Xenial 64") 
    sleep 1
    echo -e "${COLOR}Choisissez une box pour faire fonctionner votre machine virtuelle : ${NC}"
    select responseBox in "${optionsBox[@]}";do
        case ${responseBox} in
            "Ubuntu Xenial 64" ) boxChoice="xenial64";break;;
            "Ubuntu Xenial 64" ) boxChoice="xenial64";break;;
        esac
     done

     # On indique à l'utilisateur les étapes et on créé tout ce qui a été renseigné plus tôt
     echo -e "${COLOR}Création et configuration du Vagrantfile en cours.... ${NC}" 
     sleep 1
     # Création du dossier de travail
     mkdir $nomVagrant
     cd $nomVagrant
     echo -e "${COLOR}Le dossier $nomVagrant a bien été créé ${NC}"
     sleep 1
     # Création du dossier de synchronisation
     mkdir $nomSync
     echo -e "${COLOR}Le dossier synchronisé $nomSync a bien été créé ${NC}"
     sleep 1
     cp ../installation.sh ../$nomVagrant/$nomSync
     echo -e "${COLOR}Le script d'installation a bien été copié dans $nomVagrant/$nomSync ${NC}"

    sleep 2
     # Création du fichier Vagrantfile
     vagrant init

    # On modifie le fichier Vagrantfile avec les informations indiquées par l'utilisateur
    sed -i '15s/base/ubuntu\/'"${boxChoice}"'/' Vagrantfile
    sed -i '35s/#//' Vagrantfile
    sed -i '46s/#//' Vagrantfile
    sed -i '46s/..\/data/.\/'"${nomSync}"'/' Vagrantfile
    sed -i '46s/\/vagrant_data/\/var\/www\/html/' Vagrantfile

    # On modifie le fichier /etc/hosts afin de rediriger l'IP vers le domaine choisi plus tôt
    # sed "2 i 192.168.33.10   ${nomDomaine}" /etc/hosts
    
     # On lance la vagrant 
    sleep 2
    vagrant up  
    
    vagrantSSH
}

function vagrantRun {
    # On affiche les machines qui sont déjà en train de fonctionner
    echo -e "${COLOR}Actuellement, voici les vagrant en cours d'utilisation : ${NC}"
    vagrant global-status
    
    # On demande à l'utilisateur de choisir la machine à utiliser
    optionsVagrant=("Eteindre une vagrant" "Eteindre toutes les vagrant") 
    sleep 1
    echo -e "${COLOR}Que voulez vous faire ? ${NC}"
    select responseVagrant in "${optionsVagrant[@]}";do
        case ${responseVagrant} in
            "Eteindre une vagrant" ) actionVagrant="shutDown";break;;
            "Eteindre toutes les vagrant" ) actionVagrant="shutDownAll";break;;
        esac
    done
    
    # Eteindre une vagrant en marche
    if [ "$actionVagrant" == "shutDown" ]
        then
        sleep 1
        echo -e "${COLOR}Quelle machine voulez vous éteindre ? (ID)${NC}"
        read -p idDown
        sleep 1
        vagrant halt $idDown
        echo -e "${COLOR}La vagrant $idDown a bien été éteinte${NC}"
        sleep 1 
    fi
     # Eteindre toutes les vagrant en marche
    if [ "$actionVagrant" == "shutDownAll" ]
        then
        sleep 1
        echo -e "${RED}Code non terminé ! Désolée (:${NC}"
        sleep 2
        exit
    fi
    
}

function vagrantSSH {
    echo -e "${COLOR}CONNEXION SSH EN COURS... ${NC}"
    sleep 1
    echo -e "${COLOR}Une fois connecté, merci de faire un cd /var/www/html${NC}"
    sleep 1
    echo -e "${COLOR}Ensuite, veuillez éxécuter le script installation.sh ${NC}"
    echo -e "${COLOR}( bash installation.sh ) ${NC}"
    sleep 2
    vagrant ssh
}

function vagrantInstaller {
optionsProgram=("Oui" "Non" "Je ne sais pas") 
echo -e "${COLOR}Avez-vous déjà installé Vagrant ? ${NC}"
    sleep 1
        select responseProgram in "${optionsProgram[@]}";do
            case ${responseProgram} in
                "Oui" ) actionProgram="verifProgram";break;;
                "Non" ) actionProgram="installProgram";break;;
                "Je ne sais pas" ) actionProgram="verifProgram";break;;
            esac
        done

 # Vérifier et installer le programme
    if [ "$actionProgram" == "installProgram" ]
    then
    sleep 1
    echo -e "${COLOR}Nous allons procéder à l'installation de Vagrant${NC}"
    sleep 1
        # On vérifie si Vagrant est installé
        type vagrant
        if ! type vagrant > /dev/null
            then
            # Si il n'est pas installé, on l'installe
            sudo apt-get install vagrant
            sleep 1
            echo -e "${VALIDATE}Vagrant a été installé avec succès !${NC}"
        fi
         sleep 1
         echo -e "${VALIDATE}Vagrant est déjà installé ${NC}"
         virtualboxInstaller
    fi
    

 # Vérifier si le programme est présent / demander l'installation
    if [ "$actionProgram" == "verifProgram" ]
    then
    sleep 1
    echo -e "${COLOR}Nous vérifions la présence de Vagrant sur votre ordinateur${NC}"
        # On vérifie si Vagrant est installé
        type vagrant
        if ! type vagrant > /dev/null
            then
            # Si il n'est pas installé, on demande à l'utilisateur son autorisation
            sleep 1
            echo -e "${RED}Vagrant n'est pas présent sur votre ordinateur. Ce programme est nécessaire pour passer à la suite. Voulez-vous l'installer ? (O/n) ${NC}"
            read -e responseInstall
                if [ "$responseInstall" == "O" ]
                    then
                        # On installe le programme
                        sleep 1
                        echo -e "${COLOR}Nous allons procéder à l'installation de Vagrant${NC}"
                        sudo apt-get install vagrant
                        sleep 1
                        echo -e "${VALIDATE}Vagrant a été installé avec succès !${NC}"
                        vagrantConfig
                fi
                sleep 1
                echo -e "À bientôt !"
                exit;
        fi
        # Si c'est déjà le cas, on informe l'utilisateur
        sleep 1
        echo -e "${VALIDATE}Vagrant est déjà installé ${NC}"
        virtualboxInstaller
        sleep 1
    fi

}

function virtualboxInstaller {
    optionsProgram=("Oui" "Non" "Je ne sais pas") 
    sleep 2
    echo -e "${COLOR}Avez-vous déjà installé VirtualBox ? ${NC}"
            select responseProgram in "${optionsProgram[@]}";do
                case ${responseProgram} in
                    "Oui" ) actionProgram="verifProgram";break;;
                    "Non" ) actionProgram="installProgram";break;;
                    "Je ne sais pas" ) actionProgram="verifProgram";break;;
                esac
            done

 # Vérifier et installer le programme
    if [ "$actionProgram" == "installProgram" ]
    then
    sleep 1
    echo -e "${COLOR}Nous allons procéder à l'installation de VirtualBox${NC}"
    sleep 1
        # On vérifie si Virtualbox est installé
        type virtualbox
        if ! type virtualbox > /dev/null
            then
            # Si il n'est pas installé, on l'installe
            sudo apt-get install virtualbox
            sleep 1
            echo -e "${VALIDATE}Virtualbox a été installé avec succès !${NC}"
            sleep 1
        fi
         sleep 1
         echo -e "${VALIDATE}Virtualbox est déjà installé ${NC}"
         vagrantConfig
    fi


 # Vérifier si le programme est présent et demander l'installation
    if [ "$actionProgram" == "verifProgram" ]
    then
    sleep 1
    echo -e "${COLOR}Nous vérifions la présence de Virtualbox sur votre ordinateur${NC}"
        # On vérifie si Virtualbox est installé
        type virtualbox
        if ! type virtualbox > /dev/null
            then
            # Si il n'est pas installé, on demande à l'utilisateur son autorisation
            sleep 1
            echo -e "${RED}Virtualbox n'est pas présent sur votre ordinateur. Ce programme est nécessaire pour passer à la suite. Voulez-vous l'installer ? (O/n) ${NC}"
            read -e responseInstall
                if [ "$responseInstall" == "O" ]
                    then
                        # On installe le programme
                        echo -e "${COLOR}Nous allons procéder à l'installation de Virtualbox${NC}"
                        sudo apt-get install virtualbox
                        sleep 1
                        echo -e "${VALIDATE}Virtualbox a été installé avec succès !${NC}"
                        vagrantConfig
                fi
                sleep 1
                echo -e "À bientôt !"
                exit;
        fi
        # Si c'est déjà le cas, on informe l'utilisateur
        sleep 1
        echo -e "${VALIDATE}Virtualbox est déjà installé ${NC}"
        vagrantConfig
    fi
}


echo -e "${COLOR}Bonjour !${NC}"
sleep 1
echo -e "${COLOR}Bienvenue dans la création de votre machine virtuelle${NC}"
sleep 1

vagrantInstaller
