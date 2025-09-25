#!/bin/bash
set -e

DATA_DIR="/var/lib/postgresql/data"

if [ ! -s "$DATA_DIR/PG_VERSION" ]; then
    su - postgres -c "/usr/lib/postgresql/16/bin/initdb -E UTF8 -D $DATA_DIR"
    su - postgres -c "/usr/lib/postgresql/16/bin/pg_ctl -D $DATA_DIR -l $DATA_DIR/logfile start"
    su - postgres -c "createuser -d -R -S odoo"
    su - postgres -c "/usr/lib/postgresql/16/bin/pg_ctl -D $DATA_DIR stop"
fi

echo "==== Démarrage PostgreSQL en foreground ===="
su - postgres -c "/usr/lib/postgresql/16/bin/postgres -D $DATA_DIR" &

echo "==== Démarrage de code-server ===="
exec su - odoo -c "code-server --bind-addr 0.0.0.0:8080"
