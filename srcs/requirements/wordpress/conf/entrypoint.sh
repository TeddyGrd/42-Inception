#!/bin/bash

echo "🔧 Vérification de la configuration WordPress..."

# Vérifier si WordPress est déjà installé
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "📥 Téléchargement de WordPress..."
    curl -o /tmp/wordpress.tar.gz https://wordpress.org/wordpress-6.4.3.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
    rm /tmp/wordpress.tar.gz
    chown -R www-data:www-data /var/www/html

    echo "⚙️ Configuration de wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/html/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" /var/www/html/wp-config.php
fi

echo "🚀 Lancement de PHP-FPM..."
exec php-fpm82 -F
