#!/bin/sh

cd /var/www
# set laravel.log readable/writable for www-data user
setfacl -d -m group:www-data:rwx /var/www/storage/logs

# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

/usr/bin/supervisord -c /etc/supervisord.conf