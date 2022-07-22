#!/bin/sh

cd /var/www

# php artisan migrate:fresh --seed
su www -c "php artisan cache:clear"
su www -c "php artisan route:cache"

/usr/bin/supervisord -c /etc/supervisord.conf