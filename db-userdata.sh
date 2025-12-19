#!/bin/bash
set -euo pipefail

LOG="/var/log/db-userdata.log"
exec > >(tee -a "$LOG") 2>&1

echo "===== DB Server bootstrap started ====="

# Variables
APP_SUBNET="192.168.4.%"
DB_NAME="media"
DB_USER="appuser"
DB_PASS="StrongAppPassword!"
ROOT_PASS="StrongRootPassword!"

# Detect Private IP
PRIVATE_IP=$(hostname -I | awk '{print $1}')

echo "Private IP detected: $PRIVATE_IP"

# ---------------------------
# OS Prep
# ---------------------------
apt update -y
apt install -y mysql-server net-tools curl unzip nano ufw

systemctl enable mysql
systemctl start mysql

# ---------------------------
# Secure MySQL root user
# ---------------------------
# mysql <<EOF
# ALTER USER 'root'@'localhost'
# IDENTIFIED WITH mysql_native_password BY '${ROOT_PASS}';
# FLUSH PRIVILEGES;
# EOF
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

# ---------------------------
# Bind MySQL to Private IP
# ---------------------------
sed -i "s/^bind-address.*/bind-address = ${PRIVATE_IP}/" \
	/etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql

# ---------------------------
# Create DB, User, Tables
# ---------------------------
mysql -u root -p"${ROOT_PASS}" <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

CREATE USER IF NOT EXISTS '${DB_USER}'@'${APP_SUBNET}'
IDENTIFIED BY '${DB_PASS}';

GRANT SELECT, INSERT, UPDATE, DELETE
ON ${DB_NAME}.*
TO '${DB_USER}'@'${APP_SUBNET}';

FLUSH PRIVILEGES;

USE ${DB_NAME};

CREATE TABLE IF NOT EXISTS movies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS songs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

INSERT IGNORE INTO movies (name) VALUES
('Inception'),
('Interstellar'),
('Matrix')
('Pirates of the Caribbean: The Curse of the Black Pearl (2003)'),
('Pirates of the Caribbean: Dead Man's Chest (2006)'),
('Pirates of the Caribbean: At World's End (2007)'),
(''Pirates of the Caribbean: On Stranger Tides (2011)'),
('Pirates of the Caribbean'),
('Pirates of the Caribbean: Dead Men Tell No Tales (2017)'),
('The Lord of the Rings: The Fellowship of the Ring (2001)'),
('The Lord of the Rings: The Two Towers (2002)'),
('The Lord of the Rings: The Return of the King (2003)'),
('The Hobbit: An Unexpected Journey (2012)'),
('The Hobbit: The Desolation of Smaug (2013)'),
('The Hobbit: The Battle of the Five Armies (2014)');

INSERT IGNORE INTO songs (name) VALUES
('Believer'),
('Faded'),
('Closer'),
('Shape of You'),
('Blinding Lights'),
('Levitating'),
('Peaches'),
('Save Your Tears'),
('Watermelon Sugar'),
('Bad Guy');
EOF

# ---------------------------
# UFW Hardening (Optional)
# ---------------------------
ufw allow from 192.168.4.0/24 to any port 3306
ufw --force enable

echo "===== DB Server bootstrap completed ====="
