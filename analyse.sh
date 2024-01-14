#!/bin/bash

# Fonction pour afficher l'usage du script
show_usage() {
    echo "analyse.sh: [-h] [-v] [-t] [-m] [-g] [-v] [-n] [-p] user.."
}

# Fonction pour afficher l'aide détaillée à partir d'un fichier texte
show_help() {
    cat help.txt
}

# Fonction pour retourner le nombre d'utilisateurs
get_user_count() {
    local count=$(grep -c "/bin/bash" /etc/passwd)
    echo "Nombre d'utilisateurs : $count"
}

# Fonction pour afficher la liste des utilisateurs
show_user_list() {
    awk -F: '{print $1}' /etc/passwd
}

# Fonction pour afficher les noms des utilisateurs et leurs répertoires personnels
show_user_directories() {
    awk -F: '{printf "%-20s %s\n", $1, $6}' /etc/passwd
}

# Fonction pour afficher les utilisateurs ayant un groupe primaire spécifié
show_users_by_primary_group() {
    local group=$1
    awk -F: -v group="$group" '$4 == group {print $1}' /etc/passwd
}

# Fonction pour afficher le type de l'utilisateur (admin, applicatif, simple)
show_user_type() {
    local user=$1
    local type="simple"
    
    if [[ $user == "root" ]]; then
        type="admin"
    elif [[ $(groups "$user" | grep -c "sudo") -gt 0 ]]; then
        type="admin"
    fi
    
    echo "Type de l'utilisateur $user : $type"
}

# Options par défaut
help=false
graphical_menu=false
verbose=false
show_user_count=false
show_user_directories=false
show_users_by_group=false
show_user_type=false

# Traitement des arguments en ligne de commande
while getopts "hgmtvnpGt:" option; do
    case $option in
        h)
            help=true
            ;;
        g)
            graphical_menu=true
            ;;
        m)
            echo "Menu textuel non implémenté"
            ;;
        t)
            show_user_type=true
            user_to_check="$OPTARG"
            ;;
        v)
            verbose=true
            ;;
        n)
            show_user_count=true
            ;;
        p)
            show_user_directories=true
            ;;
        G)
            show_users_by_group=true
            group_to_check="$OPTARG"
            ;;
        *)
            show_usage >&2
            exit 1
            ;;
    esac
done

# Affichage des informations
if [ "$help" = true ]; then
    show_help
elif [ "$verbose" = true ]; then
    echo "Auteurs : John Doe, Jane Smith"
    echo "Version : 1.0"
fi

if [ "$show_user_count" = true ]; then
    get_user_count
fi

if [ "$show_user_directories" = true ]; then
    show_user_directories
fi

if [ "$show_users_by_group" = true ]; then
    show_users_by_primary_group "$group_to_check"
fi

if [ "$show_user_type" = true ]; then
    show_user_type "$user_to_check"
fi

# Si aucun argument n'est spécifié, afficher l'usage
if [ $# -eq 0 ]; then
    show_usage >&2
    exit 1
fi
