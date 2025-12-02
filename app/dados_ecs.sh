# Pega o ARN da Task
TASK_ARN=$(curl -s $ECS_CONTAINER_METADATA_URI_V4/task | jq -r '.TaskARN')
# Pega o ID do Container
CONTAINER_ID=$(hostname)

# Gera o conteúdo HTML
echo "<h1>Bem-vindo!</h1>" > /usr/share/nginx/html/index.html
echo "<h2>Servido por: $CONTAINER_ID</h2>" >> /usr/share/nginx/html/index.html
echo "<p>Task ARN (AWS ID Único): <b>$TASK_ARN</b></p>" >> /usr/share/nginx/html/index.html

# Inicia o Nginx
nginx -g 'daemon off;'