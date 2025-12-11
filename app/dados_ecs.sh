#!/bin/bash

# Define o arquivo para armazenar a cor única da Task
COLOR_FILE="/tmp/task_color.txt"

# --- 1. Geração de Cor Única ---
if [ ! -f $COLOR_FILE ]; then
    # Gera uma cor hexadecimal aleatória (ex: #A3B5C7)
    RANDOM_COLOR=$(head /dev/urandom | tr -dc A-F0-9 | head -c 6)
    echo "#$RANDOM_COLOR" > $COLOR_FILE
fi
TASK_COLOR=$(cat $COLOR_FILE)

# --- 2. Coleta de Metadados ---
TASK_ARN=$(curl -s $ECS_CONTAINER_METADATA_URI_V4/task | jq -r '.TaskARN')
CONTAINER_ID=$(hostname)

# --- 3. Geração do HTML Estilizado ---
cat << EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Teste de ALB</title>
    <style>
        body {
            background-color: $TASK_COLOR; /* Cor ÚNICA por servidor! */
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        .container {
            background-color: rgba(0, 0, 0, 0.5);
            padding: 20px;
            border-radius: 10px;
            display: inline-block;
        }
        h1 { font-size: 3em; }
        p { font-size: 1.5em; }
    </style>
</head>
<body>
    <div class="container">
        <h1> Servidor Ativo: $CONTAINER_ID</h1>
        <hr>
        <p><strong>Task ARN (Identificador ECS):</strong><br><code>$TASK_ARN</code></p>
    </div>
</body>
</html>
EOF

# Inicia o Nginx
nginx -g 'daemon off;'