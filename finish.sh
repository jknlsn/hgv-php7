#!/bin/bash         

echo "Removing Directories"
cd ..
rm -rf hgv-php7
/usr/bin/mysql_secure_installation
sudo service varnish restart && sudo service nginx restart