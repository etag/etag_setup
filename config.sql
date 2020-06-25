create database etag;
create database etag_auth;
create user etag_master with password 'etag_master';
GRANT ALL PRIVILEGES ON DATABASE "etag" to etag_master;
GRANT ALL PRIVILEGES ON DATABASE "etag_auth" to etag_master;
