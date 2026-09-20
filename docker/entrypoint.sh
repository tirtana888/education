#!/bin/bash
set -euo pipefail

: "${DB_HOST:?DB_HOST is required}"
: "${DB_ROOT_PASSWORD:?DB_ROOT_PASSWORD is required}"
: "${REDIS_URL:?REDIS_URL is required}"
: "${ADMIN_PASSWORD:?ADMIN_PASSWORD is required}"

SITE_NAME="${SITE_NAME:-frontend}"
DB_PORT="${DB_PORT:-3306}"
BENCH=/home/frappe/frappe-bench
cd "$BENCH"

mkdir -p sites logs
chown -R frappe:frappe sites logs
rm -rf sites/assets
ln -s "$BENCH/assets" sites/assets

echo "Waiting for database at $DB_HOST:$DB_PORT..."
wait-for-it -t 180 "$DB_HOST:$DB_PORT"

redis_host="${REDIS_URL#*://}"
redis_host="${redis_host%%/*}"
echo "Waiting for Redis at $redis_host..."
wait-for-it -t 180 "$redis_host"

ls -1 apps > sites/apps.txt
if [ ! -f sites/common_site_config.json ]; then
  echo '{}' > sites/common_site_config.json
fi
chown frappe:frappe sites/apps.txt sites/common_site_config.json

runuser -u frappe -- bench set-config -g db_host "$DB_HOST"
runuser -u frappe -- bench set-config -gp db_port "$DB_PORT"
runuser -u frappe -- bench set-config -g redis_cache "$REDIS_URL"
runuser -u frappe -- bench set-config -g redis_queue "$REDIS_URL"
runuser -u frappe -- bench set-config -g redis_socketio "$REDIS_URL"
runuser -u frappe -- bench set-config -gp socketio_port 9000
runuser -u frappe -- bench set-config -g default_site "$SITE_NAME"
runuser -u frappe -- bench set-config -g chromium_path /usr/bin/chromium-headless-shell

if [ ! -f "sites/$SITE_NAME/site_config.json" ] || ! runuser -u frappe -- bench --site "$SITE_NAME" list-apps 2>/dev/null | grep -q "education"; then
  echo "Site $SITE_NAME does not have Frappe Education installed. Initializing clean site..."
  runuser -u frappe -- bench new-site "$SITE_NAME" \
    --force \
    --mariadb-user-host-login-scope='%' \
    --admin-password "$ADMIN_PASSWORD" \
    --db-root-username root \
    --db-root-password "$DB_ROOT_PASSWORD" \
    --no-mariadb-socket
  echo "Installing ERPNext into site $SITE_NAME..."
  runuser -u frappe -- bench --site "$SITE_NAME" install-app erpnext
  echo "Installing Frappe Education into site $SITE_NAME..."
  runuser -u frappe -- bench --site "$SITE_NAME" install-app education
  runuser -u frappe -- bench --site "$SITE_NAME" enable-scheduler
else
  echo "Existing Education site found. Running database migrations..."
  runuser -u frappe -- bench --site "$SITE_NAME" migrate
fi

runuser -u frappe -- bench --site "$SITE_NAME" clear-cache
runuser -u frappe -- bench --site "$SITE_NAME" clear-website-cache
runuser -u frappe -- bench use "$SITE_NAME"

echo "Frappe Education site setup complete. Handing over to Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
