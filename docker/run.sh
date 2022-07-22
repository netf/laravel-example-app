#!/bin/sh

cd /var/www

# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

chmod www-data:www-data -R /var/www/storage/logs

/usr/bin/supervisord -c /etc/supervisord.conf