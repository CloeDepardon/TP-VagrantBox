# Script VagrantBox

Ces deux scripts (script.sh et installation.sh) sont à enregistrer au même endroit. 

# script.sh

- Le script peut être lancé de n'importe quel dossier, sa position ne conditionne pas la réussite de la création de la VM
- Il va, dans l'ordre :
  - Vérifier si Vagrant et Virtualbox sont présents sur le PC. Si ce n'est pas le cas, il propose à l'utilisateur de les installer
  - Créer un dossier qui accueillera la VM et un dossier de synchronisation
  - Créer un fichier Vagrantfile et le configurer 
  - Lancer la Vagrant et la connexion SSH
  
Une fois ce script terminé, la connexion SSH s'effectue et l'utilisateur doit effectuer un cd /var/www/html puis éxécuter le deuxième script : installation.sh
À noter : ce script contient une fonction vagrantRun permettant de gérer les VM en cours d'utilisation. Elle n'est pas terminée.

# installation.sh

- Ce script doit être lancé dans le dossier synchronisé en SSH, donc dans /var/www/html
- L'utilisateur peut choisir les packages qu'il souhaite installer
- La vérification des packages avant installation n'est pas mise en place, faute de temps
