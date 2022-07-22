#!/bin/sh

cd /var/www
setfacl -d -m group:www-data:rwx /var/www/storage/logs

# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

/usr/bin/supervisord -c /etc/supervisord.conf