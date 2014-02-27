# Init script for DOMAIN

echo "Commencing DOMAIN"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS DOMAIN;"
mysql -u root --password=root -e "CREATE USER 'DOMAIN'@'localhost' IDENTIFIED BY 'PASSWORD1234';"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON DOMAIN.* TO DOMAIN@localhost IDENTIFIED BY 'PASSWORD1234';"

# Download WordPress
if [ ! -d public_html ]
then
	echo "Installing WordPress using WP CLI"
	mkdir public_html
	mkdir logs
	cd public_html
	wp core download --allow-root
	wp core config --dbname="DOMAIN" --dbuser=DOMAIN --dbpass=PASSWORD1234 --dbhost="localhost" --allow-root
	wp core install --url=DOMAIN.dev --title="DOMAIN" --admin_user=DOMAIN --admin_password=PASSWORD1234 --admin_email=dev@demothesite.com --allow-root
	#WordPress Settings
	wp rewrite structure '/%postname%/' --allow-root
	wp theme delete twentytwelve --allow-root
	wp theme delete twentythirteen --allow-root
	#default plugins
	wp plugin install wp101 --activate --allow-root
	#woocommerce plugins
	cd .. --allow-root
fi

# The Vagrant site setup script will restart Nginx for us

echo "DOMAIN now installed";
