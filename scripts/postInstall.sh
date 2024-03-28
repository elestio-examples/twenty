#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;

target=$(docker-compose port server 3000)

curl http://target/graphql \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'authorization;' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw $'{"operationName":"SignUp","variables":{"email":"'${ADMIN_EMAIL}'","password":"'${ADMIN_PASSWORD}'"},"query":"mutation SignUp($email: String\u0021, $password: String\u0021, $workspaceInviteHash: String) {\\n  signUp(\\n    email: $email\\n    password: $password\\n    workspaceInviteHash: $workspaceInviteHash\\n  ) {\\n    loginToken {\\n      ...AuthTokenFragment\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n\\nfragment AuthTokenFragment on AuthToken {\\n  token\\n  expiresAt\\n  __typename\\n}"}'

  docker-compose down;

  sed -i "s~IS_SIGN_UP_DISABLED=false~IS_SIGN_UP_DISABLED=true~g" ./.env

  docker-compose up -d;

  sleep 30s;