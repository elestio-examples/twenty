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

      ENABLE_DB_MIGRATIONS: "false" # it already runs on the server

      STORAGE_TYPE: local
      STORAGE_LOCAL_PATH: .local-storage

      ACCESS_TOKEN_SECRET: ${ACCESS_TOKEN_SECRET}
      LOGIN_TOKEN_SECRET: ${LOGIN_TOKEN_SECRET}
      REFRESH_TOKEN_SECRET: ${REFRESH_TOKEN_SECRET}
      FILE_TOKEN_SECRET: ${FILE_TOKEN_SECRET}

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


More details check their upgrade doc https://twenty.com/developers/section/self-hosting/upgrade-guide
