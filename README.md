# Mercury Vagrant (HGV) for One Deployment Playbook

[Originally cloned from Zach Adams HGV-deploy-full](https://github.com/zach-adams/hgv-deploy-full/)

## Introduction

This Ansible Playbook is designed to setup a [Mercury-Like](https://github.com/wpengine/hgv/) environment on a Production server without the configuration hassle. This playbook was forked from [Zach Adams Mercury Playbook](https://github.com/zach-adams/hgv-deploy-full/), itself forked from [WPEngine's Mercury Vagrant](https://github.com/wpengine/hgv/). 

Added are options to change the site URL and the admin email address.

*Note: Remember not to run weird scripts on your server as root without reviewing them first. Please review this playbook to ensure I'm not installing malicious software.*

This Playbook will setup:

- **Percona DB** (MySQL) (Looking for MariaDB? Try [this](https://github.com/xDae/hgv-deploy-full))
- **HHVM** (Default PHP Parser)
- **PHP-FPM** (Backup PHP Parser)
- **Nginx**
- **Varnish** (Running by default)
- **Memcached and APC**
- **Clean WordPress Install** (Latest Version)
- **WP-CLI**

#### This playbook will only run on Ubuntu 14.04 LTS

## Installation

1. SSH onto a newly created server
1.5. Add necessary Apt package (if not already installed) with `sudo apt-get install software-properties-common`
2. Add Ansible with `sudo add-apt-repository ppa:ansible/ansible`
3. Update Apt with `sudo apt-get update && sudo apt-get upgrade`
4. Install Git and Ansible with `sudo apt-get install ansible git`
5. Clone this repository with `git clone https://github.com/jknlsn/hgv-reusable/`
6. Move into the "hgv-resuable folder" with `cd hgv-reusable`
7. Edit the `hosts` file and change `website` to your folder name for your website with the command `nano hosts`, or any text editor.
8. Edit the name of `website` file in the `host_vars` folder to your folder name for your website.
9. Change your sites specific information **including passwords** inside the hostname file inside the `host_vars` directory
10. Run Ansible with `sudo ansible-playbook -i hosts playbook.yml -c local`.
11. Remove the cloned git directory from your server with `rm -rf hgv-reusable/`
12. Run `/usr/bin/mysql_secure_installation` to install MySQL and secure it. Your root password will be blank by default
13. Restart Varnish and Nginx with: `sudo service varnish restart && sudo service nginx restart`
14. You're good to go! A new WordPress install running HHVM and Varnish should be waiting for you at your hostname!

## Turning off Varnish (Use only Nginx)

If you are having issues making changes or having issues with the backend while using Varnish, you can turn it off and just use Nginx while maintaining good performance. Here's how you can do that:

1. Open each of the Nginx configurations of the sites installed on your server with `sudo nano /etc/nginx/sites-available/your-hostname.com`
2. Change `listen = 8080;` to `listen = 80;` 
3. Make sure you do this to **all** sites installed on your server
4. Stop Varnish and Restart Nginx with `sudo service varnish stop && sudo service nginx restart`
5. You should be good to go! If you do not have a caching plugin installed I would highly recommend one.

## Switching HHVM back to PHP-FPM

Your Nginx configuration should automatically facilitate switching to PHP-FPM if there's an issue with HHVM, however if you want to switch back manually you can do so like this:

1. Open your Nginx configuration with `vim|emacs|nano /etc/nginx/sites-available/( Your Hostname )`
2. Find the following section towards the bottom:

```
    location ~ \.php$ {
        proxy_intercept_errors on;
        error_page 500 501 502 503 = @fallback;
        fastcgi_buffers 8 256k;
        fastcgi_buffer_size 128k;
        fastcgi_intercept_errors on;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass hhvm;
    }
```

3. Change `fastcgi_pass hhvm;` to `fastcgi_pass php;`
4. Restart Nginx with `sudo service nginx restart`
5. You should now be running PHP-FPM! Check to make sure using `phpinfo();`

## Issues

Please report any issues through GitHub and I'll do my best to get back to you!

## Bugs / known issues

1. WordPress Customizer doesn't work with Varnish set up. To resolve, follow the aboves step to turn off Varnish and then reverse when done.
# hgv-php7
