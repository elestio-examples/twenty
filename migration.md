### Add the worker service to the docker-compose.yml if in case not found.
```
  worker:
    image: twentycrm/twenty:${SOFTWARE_VERSION_TAG}
    command: ["yarn", "worker:prod"]
    environment:
      PG_DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      SERVER_URL: ${SERVER_URL}
      FRONT_BASE_URL: ${SERVER_URL}
      REDIS_PORT: 6379
      REDIS_HOST: redis
      REDIS_URL: redis://redis:6379

      ENABLE_DB_MIGRATIONS: "false" # it already runs on the server

      STORAGE_TYPE: local
      STORAGE_LOCAL_PATH: .local-storage

      ACCESS_TOKEN_SECRET: ${ACCESS_TOKEN_SECRET}
      LOGIN_TOKEN_SECRET: ${LOGIN_TOKEN_SECRET}
      REFRESH_TOKEN_SECRET: ${REFRESH_TOKEN_SECRET}
      FILE_TOKEN_SECRET: ${FILE_TOKEN_SECRET}
      APP_SECRET: ${APP_SECRET}

      EMAIL_FROM_ADDRESS: ${EMAIL_FROM_ADDRESS}
      EMAIL_SYSTEM_ADDRESS: ${EMAIL_FROM_ADDRESS}
      EMAIL_FROM_NAME: "Twenty"
      EMAIL_DRIVER: smtp
      EMAIL_SMTP_HOST: ${EMAIL_SMTP_HOST}
      EMAIL_SMTP_PORT: ${EMAIL_SMTP_PORT}
      PASSWORD_RESET_TOKEN_EXPIRES_IN: 5m
      FRONT_AUTH_CALLBACK_URL: ${SERVER_URL}/verify
      IS_SIGN_UP_DISABLED: "true"
      LOG_LEVELS: log,error,warn
    depends_on:
      - db
      - server
    restart: always
```

### Upgrade from v0.23.0 to v0.24.0
```
docker-compose exec -T server sh -c "yarn database:migrate:prod"
docker-compose exec -T server sh -c "yarn command:prod upgrade-0.24"
```
### Upgrade from v0.24.0 to v0.30.0
```
docker-compose exec -T server sh -c "yarn database:migrate:prod"
docker-compose exec -T server sh -c "yarn command:prod upgrade-0.30"
```

### Upgrade from v0.30.0 to v0.31.0
```
docker-compose exec -T server sh -c "yarn database:migrate:prod"
docker-compose exec -T server sh -c "yarn command:prod upgrade-0.31"
```
### Upgrade from v0.31.0 to v0.32.0
The following environment variables have been changed:
```
Removed: REDIS_HOST, REDIS_PORT, REDIS_USERNAME, REDIS_PASSWORD
Added: REDIS_URL
```
Update your .env file to use the new `REDIS_URL` variable instead of the individual Redis connection parameters


For more details check their upgrade doc https://twenty.com/developers/section/self-hosting/upgrade-guide
