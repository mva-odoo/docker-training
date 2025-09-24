#!/bin/bash
set -e

DATA_DIR="/var/lib/postgresql/data"

echo "==== Vérification PostgreSQL ===="
if [ ! -s "$DATA_DIR/PG_VERSION" ]; then
    echo ">>> Initialisation du cluster PostgreSQL..."
    su - postgres -c "/usr/lib/postgresql/14/bin/initdb -E UTF8 -D $DATA_DIR"
    su - postgres -c "createuser -d -R -S odoo"
    su - postgres -c "createdb -O odoo odoo || true"
fi

echo "==== Démarrage PostgreSQL en foreground ===="
su - postgres -c "/usr/lib/postgresql/14/bin/postgres -D $DATA_DIR" &

echo "==== Démarrage de code-server ===="
exec su - odoo -c "code-server --bind-addr 0.0.0.0:8080"
