#!/bin/bash         

echo "Removing Directories"
rm -rf hgv-php7
/usr/bin/mysql_secure_installation
sudo service varnish restart && sudo service nginx restart

echo "Done! Go to your new site now to check that it's working."