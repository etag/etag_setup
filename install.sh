#!/bin/bash

# This setup script has been tested under Ubuntu 18.04 LTS Server
# The active user must be a member of the sudo and docker groups

export cwd="$(pwd)"


# Setup directories and permissions
sudo mkdir /data
sudo chgrp -R etag /data
sudo chmod -R 775 /data
mkdir /data/postgres
#TODO: confirm and add missing required directories

sudo chgrp -R etag /opt
sudo chmod -R 775 /opt


# Fetch cybercommons and apply ETAG defaults
cd /opt
cookiecutter https://github.com/cybercommons/cybercom-cookiecutter --config-file "$cwd/config.yml" --no-input


# Apply custom configuration patches
cd "$cwd"
patch -b /opt/etag/config/api_config.py -i api_config.patch
patch -b /opt/etag/config/celery/code/celeryconfig.py -i celeryconfig.patch
patch -b /opt/etag/config/celery/code/requirements.txt -i celeryrequirements.patch
patch -b /opt/etag/run/cybercom_up -i cybercom_up.patch


# Get ETAG API
rm -rf /opt/etag/api_code
git clone https://github.com/etag/etag-api /opt/etag/api_code
cd /opt/etag/api_code
docker build -t api .


# Initialize Postgres DB

# Clone ETAG schema
git clone https://github.com/etag/etag_schema /opt/etag/etag_schema

docker run -d --name=etag_postgres \
  -e POSTGRES_PASSWORD=etag_master \
  -v /data/postgres:/var/lib/postgresql/data \
  postgres:11

echo "Sleeping for 10 seconds to give Postgres a chance to startup..."
sleep 10

# Create databases and access
docker cp "$cwd/config.sql" etag_postgres:/tmp/config.sql
docker exec -it etag_postgres psql \
  -U postgres \
  -d postgres \
  -f /tmp/config.sql

# Load ETAG specific schema
docker cp /opt/etag/etag_schema/etag_schema_script.sql etag_postgres:/tmp/etag_schema_script.sql
docker exec -it etag_postgres psql \
  -U postgres \
  -d postgres \
  -f /tmp/etag_schema_script.sql

docker stop etag_postgres
docker rm etag_postgres


#FIXME: need to run django migrations
#docker run -it --rm \
#  --link etag_postgres:cybercom_postgres \
#echo "*********  API       *********************"
#docker run -d --name etag_api \
#  --link etag_memcache:cybercom_memcache \
#  --link etag_mongo:cybercom_mongo \
#  --link etag_rabbitmq:cybercom_rabbitmq \
#  --link etag_postgres:cybercom_postgres \
#  -p 8080:8080 \
#  -v /opt/etag/config/ssl/backend:/ssl:z \
#  -v /opt/etag/api_code:/usr/src/app:z \
#  -v /opt/etag/config/api_config.py:/usr/src/app/api/config.py:z \
#  -v /opt/etag/config/db.sqlite3:/usr/src/app/db.sqlite3:z \
#  -v /opt/etag/log:/log:z \
#  -v /opt/etag/data:/data:z \
#  api


#TODO: clone portal, build, and deploy to static directory

# Startup cyberCommons / ETAG
cd /opt/etag
./run/cybercom_up


