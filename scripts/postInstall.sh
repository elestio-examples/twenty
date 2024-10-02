#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 150s;


docker-compose exec -T server sh -c "yarn database:init:prod"
docker-compose exec -T server sh -c "yarn database:migrate:prod"

curl ${SERVER_URL}/graphql \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'authorization;' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36' \
  --data-raw '{
    "operationName": "SignUp",
    "variables": {
      "workspacePersonalInviteToken": null,
      "email": "'"${ADMIN_EMAIL}"'",
      "password": "'"${ADMIN_PASSWORD}"'"
    },
    "query": "mutation SignUp($email: String!, $password: String!, $workspaceInviteHash: String, $workspacePersonalInviteToken: String = null, $captchaToken: String) { signUp( email: $email password: $password workspaceInviteHash: $workspaceInviteHash workspacePersonalInviteToken: $workspacePersonalInviteToken captchaToken: $captchaToken ) { loginToken { ...AuthTokenFragment __typename } __typename }} fragment AuthTokenFragment on AuthToken { token expiresAt __typename }"
  }'

  docker-compose down;

  sleep 10s;
  sed -i 's~IS_SIGN_UP_DISABLED: "false"~IS_SIGN_UP_DISABLED: "true"~g' ./docker-compose.yml

  docker-compose up -d;

  sleep 30s;
