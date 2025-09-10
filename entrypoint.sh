#!/bin/bash

set -e

# Set default values
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='maiten'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='/s6lGcTBHpzLxcJB0j3DxKNm1raTjnZVf4Gw/UvU09w='}}}

# Create config directory if it doesn't exist
mkdir -p /etc/odoo

# Generate odoo.conf if it doesn't exist
if [ ! -f /etc/odoo/odoo.conf ]; then
    cat > /etc/odoo/odoo.conf <<EOF
[options]
addons_path = /opt/odoo/addons,/mnt/extra-addons
data_dir = /var/lib/odoo
admin_passwd = admin123
db_host = ${HOST}
db_port = ${PORT}
db_user = ${USER}
db_password = ${PASSWORD}
logfile = /var/log/odoo/odoo.log
log_level = info
workers = 2
max_cron_threads = 1
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
limit_time_cpu = 600
limit_time_real = 1200
EOF
fi

# Create log directory
mkdir -p /var/log/odoo
chown odoo:odoo /var/log/odoo

# Wait for PostgreSQL to be ready
until pg_isready -h ${HOST} -p ${PORT} -U ${USER}; do
    echo "Waiting for PostgreSQL to be ready..."
    sleep 2
done

# Run the command
exec "$@"