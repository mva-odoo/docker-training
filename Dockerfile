FROM ubuntu:jammy

# install latest postgresql-client
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-contrib postgresql-client git python3-pip libldap2-dev libpq-dev libsasl2-dev curl htop vim

RUN useradd -m -d /home/odoo -s /bin/bash odoo \
    && echo "odoo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /var/lib/postgresql/data && chown -R postgres:postgres /var/lib/postgresql
COPY ./entrypoint.sh /
COPY config.yaml /home/odoo/.config/code-server/config.yaml

USER postgres

USER odoo
RUN mkdir -p /home/odoo/src/custo
RUN  git clone https://github.com/odoo/odoo.git /home/odoo/src/odoo --depth 1 --branch 17.0
RUN pip3 install -r /home/odoo/src/odoo/requirements.txt

EXPOSE 5432 8069 8080
USER root
RUN chown -R odoo:odoo /home/odoo/.config

RUN mkdir -p /mnt/extra-addons && chown -R odoo /mnt/extra-addons
VOLUME ["/home/odoo/src/custo"]

RUN curl -fsSL https://code-server.dev/install.sh | sh

ENTRYPOINT ["/entrypoint.sh"]