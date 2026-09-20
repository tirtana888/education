FROM docker.io/frappe/erpnext:v16.34.2

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && rm -rf /var/lib/apt/lists/*

USER frappe
WORKDIR /home/frappe/frappe-bench

# Copy the forked education app repository into apps/education
COPY --chown=frappe:frappe . /home/frappe/frappe-bench/apps/education

# Install the education app and compile its assets
RUN ./env/bin/pip install -e ./apps/education \
    && echo "education" >> sites/apps.txt \
    && bench build --app education \
    && rm -rf /home/frappe/frappe-bench/assets \
    && cp -r /home/frappe/frappe-bench/sites/assets /home/frappe/frappe-bench/assets

USER root
COPY docker/entrypoint.sh /usr/local/bin/education-entrypoint
COPY docker/supervisord.conf /etc/supervisor/conf.d/education.conf
RUN chmod 755 /usr/local/bin/education-entrypoint

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/education-entrypoint"]
