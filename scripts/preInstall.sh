#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./server-local-data
chown -R 1000:1000 ./server-local-data

ACCESS_TOKEN_SECRET=$(openssl rand -base64 32)
LOGIN_TOKEN_SECRET=$(openssl rand -base64 32)
REFRESH_TOKEN_SECRET=$(openssl rand -base64 32)
FILE_TOKEN_SECRET=$(openssl rand -base64 32)

cat << EOT >> ./scripts/config.sh

ACCESS_TOKEN_SECRET=${ACCESS_TOKEN_SECRET}
LOGIN_TOKEN_SECRET=${LOGIN_TOKEN_SECRET}
REFRESH_TOKEN_SECRET=${REFRESH_TOKEN_SECRET}
FILE_TOKEN_SECRET=${FILE_TOKEN_SECRET}
EOT

cat <<EOT > ./.env
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 51175,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT