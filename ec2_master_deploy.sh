cd ~/ChatDeploy
git pull

#sudo apt install -y awscli
#mkdir -p ~/.aws

# ECR credentials
#echo "[default]
#aws_access_key_id=ASIAT7DKDJC4RQWVCNGF
#aws_secret_access_key=3iNa434cLhuJcOqaPo5CCeguk7X7MXHpTsoYbNw4
#aws_session_token=FwoGZXIvYXdzECMaDFRiPKosvWr5Gp8ZQSK/Aeo7LDdIVq+/HIFACDlgzMocFiW0G4qPv3HFiiLPf7DymbzNGmTXI2lUsM0YSdEpDA0Xz+xd8KKWTiurDFBkrrC/PToPlkhKlCPq3r9VYfxGrBcjycEme7DZRky5NEDsxYXiJCtCT0cJTEocHaQQdeHJNlof2dH/AdPA029fye4cHHvdZTrTlUQ1gfYLtsEAIU5N6HQ3l/tUKihzgoI6vJYCywg4qPrILZh/zUdWNkHx2BBShFc2aqIbATUNpa3QKNGdp/YFMi34TlUFzbBouY42SrN5+DcOPWXWD4YQJnZu30vv7HwLheuaJJdwfEVOoSiLDrc=
#" > ~/.aws/credentials
sudo $(aws ecr get-login --region us-east-1 | sed -e 's/-e none//g')

sudo docker stack deploy -c docker-compose-aws.yml --with-registry-auth chat-stack

# docker stack ps chat-stack
