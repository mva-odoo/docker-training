#!/bin/bash
set -e

# Démarrer PostgreSQL en mode foreground
DATA_DIR="/var/lib/postgresql/data"

echo "Démarrage de PostgreSQL..."
if [ ! -s "$DATA_DIR/PG_VERSION" ]; then
    echo "Initialisation du cluster PostgreSQL..."
    su - postgres -c "/usr/lib/postgresql/14/bin/initdb -E UTF8 -D $DATA_DIR"
    su - postgres -c "/usr/lib/postgresql/14/bin/pg_ctl -D $DATA_DIR -l $DATA_DIR/logfile start"
    su - postgres -c "createuser -d -R -S odoo"
else
    echo "Cluster PostgreSQL déjà initialisé, lancement..."
    su - postgres -c "/usr/lib/postgresql/14/bin/pg_ctl -D $DATA_DIR -l $DATA_DIR/logfile start"
fi

# Démarrer PostgreSQL
exec su - odoo -c "code-server --bind-addr 0.0.0.0:8080"
# exec su - odoo -c "/bin/bash" 
