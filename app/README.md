docker build -t teddy-app .

docker tag teddy-app:latest 917003953613.dkr.ecr.us-east-1.amazonaws.com/teddy-app:latest

docker push 917003953613.dkr.ecr.us-east-1.amazonaws.com/teddy-app:latest