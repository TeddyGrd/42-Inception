#!/bin/bash

echo " -> Vérification de la configuration WordPress..."

echo " -> Vérification de PHP..."
php82 -v

cd /var/www/html
ln -s /usr/bin/php82 /usr/bin/php
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/bin/php82

echo " -> Attente de MariaDB..."
until mariadb-admin ping --protocol=tcp --host="$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --wait > /dev/null 2>&1; do
    echo " -> MariaDB n'est pas encore prêt... Attente de 2 secondes."
    sleep 2
done

# Vérifier si WordPress est déjà installé
if [ ! -f /var/www/html/wp-config.php ]; then
    echo " -> Téléchargement de WordPress..."
    wp core download --path=/var/www/html --allow-root || true

    echo " -> Configuration de wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    echo " -> Installation de WordPress..."
    wp core install \
        --url="https://$DOMAIN" \
        --title="$DOMAIN incroyable" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN@$DOMAIN" \
        --skip-email \
        --allow-root

    echo " -> Installation terminée."
fi

echo " -> Désactivation des redirections forcées par WordPress..."
wp option update siteurl "https://$DOMAIN" --allow-root
wp option update home "https://$DOMAIN" --allow-root

echo " -> Suppression des redirections automatiques..."
echo "remove_filter('template_redirect', 'redirect_canonical');" >> /var/www/html/wp-config.php


chmod o+w -R /var/www/html/wp-content

echo " -> Lancement de PHP-FPM..."
exec /usr/sbin/php-fpm82 -F
