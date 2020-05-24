sudo apt install -y awscli
mkdir -p ~/.aws

# ECR credentials
cat <<EOT >> ~/.aws/credentials
[default]
aws_access_key_id=ASIAUVB4H4CE7VBB44NS
aws_secret_access_key=/ZR/LgngvtTMuJeF3aaBvhMli1WHUy3iLJQsb6Cq
aws_session_token=FwoGZXIvYXdzECIaDEfC4w7G0AA5SeOhWCK/AWAh7escUlv92L1rJ+fA2mcHEGkZuTGPUdGGBGsQ1epjwXA1JlasQpVkZSCz4PrYxsQmyGUXhymtamM8JgIrY8etIQHUCQhrOg0Lq+1CRg9mu/lfV5mZwK1jBI19X5WnvlSgeoALeooCBfkJyX5YGaamX4lb8C+R93tQCtqanIY77MIebblIqbn6O/TzyXqnLhQfXmkRTsJQ26vJW7z2ebJAPkhrq
sudo $(aws ecr get-login --region us-east-1 | sed -e 's/-e none//g')

cd ~/ChatDeploy
git pull
docker stack deploy -c docker-compose-aws.yml chat-stack
# docker stack ps chat-stack