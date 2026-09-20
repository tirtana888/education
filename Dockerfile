FROM docker.io/frappe/erpnext:v16.34.2

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor \
    && rm -rf /var/lib/apt/lists/*

USER frappe
WORKDIR /home/frappe/frappe-bench
RUN bench get-app --branch version-16 https://github.com/tirtana888/education \
    && bench build \
    && rm -rf /home/frappe/frappe-bench/assets \
    && cp -r /home/frappe/frappe-bench/sites/assets /home/frappe/frappe-bench/assets

USER root
COPY docker/entrypoint.sh /usr/local/bin/education-entrypoint
COPY docker/supervisord.conf /etc/supervisor/conf.d/education.conf
RUN chmod 755 /usr/local/bin/education-entrypoint

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/education-entrypoint"]
