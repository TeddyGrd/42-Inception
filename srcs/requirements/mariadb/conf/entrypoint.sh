#!/bin/bash

# Vérifier si la base de données est déjà initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo " -> Initialisation de la base de données..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Démarrer temporairement MariaDB pour l'initialisation
    echo " -> Lancement temporaire de MariaDB pour l'initialisation..."
    mariadbd --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0 &
    pid="$!"

    # Attendre que MariaDB soit prêt
    echo " -> Attente de MariaDB..."
    for i in {30..0}; do
        if mariadb-admin ping --silent; then
            break
        fi
        echo ' -> MariaDB en cours de démarrage...'
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo " -> MariaDB n'a pas démarré correctement, échec de l'initialisation."
        exit 1
    fi

    # Exécuter les commandes SQL pour initialiser la base et les utilisateurs
    echo " -> Création de la base de données et de l'utilisateur..."
    mariadb <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
        CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MYSQL_PASSWORD');
        GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MYSQL_ROOT_PASSWORD');
        DELETE FROM mysql.user WHERE user='';
        FLUSH PRIVILEGES;
EOSQL

    # Arrêter le processus temporaire
    echo " -> Arrêt du MariaDB temporaire..."
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo "Échec de l'arrêt du MariaDB temporaire."
        exit 1
    fi

    echo " -> Initialisation terminée."
else
    echo " -> Base de données déjà initialisée."
fi

# Démarrer MariaDB en mode serveur normal
echo " -> Démarrage de MariaDB..."
exec mariadbd --user=mysql --skip_networking=0 --datadir=/var/lib/mysql  --bind-address=0.0.0.0 --port=3306
