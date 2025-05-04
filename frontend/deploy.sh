#!/bin/bash
set -e

ng build --configuration production
if [ $? -ne 0 ]; then
    echo "❌ Angular build failed"
    exit 1
fi
echo "✅ Angular build completed"
echo "Deploying Angular to /var/www/angular-ui"

sudo rm -rf /var/www/angular-ui/*
sudo cp -r dist/frontend/browser/* /var/www/angular-ui/
sudo chown -R www-data:www-data /var/www/angular-ui
sudo chmod -R 755 /var/www/angular-ui
sudo systemctl reload nginx

echo "✅ Angular deployed to /var/www/angular-ui"
