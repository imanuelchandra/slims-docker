# slims-docker
Docker for SLiMS

create volume for database data

docker volume create -d local --name db_data\
    --opt device="/home/developer/slims/db" \
    --opt type="none" \
    --opt o="bind"


create volume for web data 

docker volume create -d local --name web_data\
    --opt device="/home/developer/slims/app" \
    --opt type="none" \
    --opt o="bind"


download source SLiMS

cd slims

wget https://github.com/slims/slims9_bulian/releases/download/v9.6.1/slims9_bulian-9.6.1.tar.gz

mkdir app

unzip slims archive file

tar -xzvf slims9_bulian-9.6.1.tar.gz -C /home/developer/slims/app
