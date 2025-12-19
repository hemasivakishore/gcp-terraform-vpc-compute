#!/bin/bash
set -euo pipefail

# Variables
DB_HOST="192.168.5.2"
DB_NAME="media"
DB_USER="appuser"
DB_PASS="StrongAppPassword!"
APP_DIR="/opt/app"
APP_PORT=8080

echo "===== App Server bootstrap started ====="

# 1. Install Dependencies
apt update -y
apt install -y python3 python3-pip curl net-tools
pip3 install flask mysql-connector-python gunicorn --break-system-packages

# 2. Create App Directory and Flask App
mkdir -p ${APP_DIR}
cat >${APP_DIR}/app.py <<EOF
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

db_config = {
    "host": "${DB_HOST}",
    "user": "${DB_USER}",
    "password": "${DB_PASS}",
    "database": "${DB_NAME}"
}

def fetch_data(table):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute(f"SELECT name FROM {table}")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        return [r[0] for r in rows]
    except Exception as e:
        return [str(e)]

@app.route("/movies")
def movies():
    return jsonify(fetch_data("movies"))

@app.route("/songs")
def songs():
    return jsonify(fetch_data("songs"))

@app.route("/health")
def health():
    return {"status": "UP"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=${APP_PORT})
EOF

# 3. Create Systemd Service for Gunicorn
cat >/etc/systemd/system/app.service <<EOF
[Unit]
Description=Gunicorn App Server
After=network.target

[Service]
User=root
WorkingDirectory=${APP_DIR}
ExecStart=/usr/local/bin/gunicorn --workers 3 --bind 0.0.0.0:${APP_PORT} app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 4. Start Service
systemctl daemon-reload
systemctl enable app
systemctl start app
