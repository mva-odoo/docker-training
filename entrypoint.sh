#!/bin/bash
set -e

# Démarrer PostgreSQL en mode foreground
DATA_DIR="/var/lib/postgresql/data"


echo "Démarrage de PostgreSQL..."
if [ -d "$DATA_DIR" ] && [ -z "$(ls -A "$DATA_DIR")" ]; then
    su - postgres -c "/usr/lib/postgresql/14/bin/initdb -E UTF8 -D /var/lib/postgresql/data"
    su - postgres -c "/usr/lib/postgresql/14/bin/pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/logfile start"
    su - postgres -c "createuser -d -R -S odoo"
fi

# Démarrer PostgreSQL
exec su - odoo -c "code-server --bind-addr 0.0.0.0:8080"
# exec su - odoo -c "/bin/bash" 
