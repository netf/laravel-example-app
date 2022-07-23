#!/bin/sh

cd /var/www
# set all files created in /var/www/storage/logs readable/writable by www-data group
setfacl -d -m group:www-data:rwx /var/www/storage/logs

# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

/usr/bin/supervisord -c /etc/supervisord.conf