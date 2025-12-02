# teste-teddy-aws


# comando login ecr

aws ecr get-login-password --region us-east-1 --profile teddy \
| docker login --username AWS --password-stdin 917003953613.dkr.ecr.us-east-1.amazonaws.com

