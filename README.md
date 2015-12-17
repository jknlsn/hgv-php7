# Mercury Vagrant with PHP7 (HGV-PHP7) Deployment Playbook

[Originally cloned from Zach Adams HGV-deploy-full](https://github.com/zach-adams/hgv-deploy-full/)

## Introduction

This Ansible Playbook is designed to setup a [Mercury-Like](https://github.com/wpengine/hgv/) environment on a Production server without the configuration hassle. This playbook was forked from [Zach Adams Mercury Playbook](https://github.com/zach-adams/hgv-deploy-full/), itself forked from [WPEngine's Mercury Vagrant](https://github.com/wpengine/hgv/). 

Some changes have been made in order to run on the new PHP7 framework.

Added are options to change the site URL and the admin email address.

*Note: Remember not to run weird scripts on your server as root without reviewing them first. Please review this playbook to ensure I'm not installing malicious software.*

This Playbook will setup:

- **Percona DB** (MySQL) (Looking for MariaDB? Try [this](https://github.com/xDae/hgv-deploy-full))
- ~~**HHVM** (Default PHP Parser)~~
- **PHP-FPM** (PHP Parser)
- **Nginx**
- **Varnish** (Running by default)
- ~~**Memcached and APC**~~ Not compatible with PHP7 at the moment.
- **Clean WordPress Install** (Latest Version, although confirmed working with 4.4 at time of writing)
- **WP-CLI**

#### This playbook will only run on Ubuntu 14.04 LTS

## Installation

1. SSH onto a newly created server
1.5. Add necessary Apt package (if not already installed) with `sudo apt-get install software-properties-common python-software-properties`
2. Add Ansible and PHP 7 repositories with `sudo add-apt-repository ppa:ondrej/php-7.0 && sudo add-apt-repository ppa:ansible/ansible`, press ENTER when requested
3. Update Apt with `sudo apt-get update && sudo apt-get upgrade`
4. Install Git and Ansible with `sudo apt-get install ansible git`
5. Clone this repository with `git clone https://github.com/jknlsn/hgv-php7/`
6. Move into the "hgv-resuable folder" with `cd hgv-php7`
7. Edit the `hosts` file and change `website` to your folder name for your website with the command `nano hosts`, or any text editor.
8. Edit the name of `website` file in the `host_vars` folder to your folder name for your website.
9. Change your sites specific information **including passwords** inside the hostname file inside the `host_vars` directory
10. Run Ansible with `sudo ansible-playbook -i hosts playbook.yml -c local`.
11. Remove the cloned git directory from your server with `rm -rf hgv-php7/`
12. Run `/usr/bin/mysql_secure_installation` to install MySQL and secure it. Your root password will be blank by default
13. Restart Varnish and Nginx with: `sudo service varnish restart && sudo service nginx restart`
14. You're good to go! A new WordPress install running PHP7.0-FPM and Varnish should be waiting for you at your hostname!

## Turning off Varnish (Use only Nginx)

If you are having issues making changes or having issues with the backend while using Varnish, you can turn it off and just use Nginx while maintaining good performance. Here's how you can do that:

1. Open each of the Nginx configurations of the sites installed on your server with `sudo nano /etc/nginx/sites-available/your-hostname.com`
2. Change `listen = 8080;` to `listen = 80;` 
3. Make sure you do this to **all** sites installed on your server
4. Stop Varnish and Restart Nginx with `sudo service varnish stop && sudo service nginx restart`
5. You should be good to go! If you do not have a caching plugin installed I would highly recommend one.

## Issues

Please report any issues through GitHub and I'll do my best to get back to you!

## Bugs / known issues

1. WordPress Customizer doesn't work with Varnish set up. To resolve, follow the aboves step to turn off Varnish and then reverse when done.
2. WordPress installation may fail due to unescaped characters in the salts variable killing Ansible. To retry, remove the files from the directory installed to, i.e. /var/www/html/website with the command `rm -rf /var/www/html/website/*`, and then re-run the playbook with `sudo ansible-playbook -i hosts playbook.yml -c local`
