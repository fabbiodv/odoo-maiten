FROM python:3.10-bullseye

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-num2words \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils \
        postgresql-client \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bullseye_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Create odoo user
RUN useradd -ms /bin/bash odoo

# Copy Odoo source code
COPY . /opt/odoo
WORKDIR /opt/odoo

# Set permissions
RUN chown -R odoo:odoo /opt/odoo

# Install Odoo
RUN pip3 install -e .

# Create directories for Odoo data
RUN mkdir -p /var/lib/odoo && chown odoo:odoo /var/lib/odoo
RUN mkdir -p /etc/odoo && chown odoo:odoo /etc/odoo

# Expose Odoo port
EXPOSE 8069

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set user back to odoo
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]