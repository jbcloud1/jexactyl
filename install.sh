#!/bin/bash
echo "Jexactly only work if pterodactyl is installed, do you want to continue"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) make install; break;;
        No ) exit;;
    esac
done
echo "Updating"
apt update
apt upgrade -y
clear
echo "Preparing install"
cp -R /var/www/pterodactyl /var/www/pterodactyl-backup
mysqldump -u root -p panel > /var/www/pterodactyl-backup/panel.sql
cd /var/www/pterodactyl
php artisan down
clear
echo "Installing"
curl -L -o panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz && rm -f panel.tar.gz
chmod -R 755 storage/* bootstrap/cache
composer require asbiin/laravel-webauthn
composer install --no-dev --optimize-autoloader
php artisan optimize:clear
php artisan migrate --seed --force
chown -R www-data:www-data /var/www/pterodactyl/*
clear
echo "Finishing install"
php artisan queue:restart
php artisan up
echo "Jexactly have been Installed"
exit
