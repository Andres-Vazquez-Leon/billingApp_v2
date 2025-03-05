#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create the user
    CREATE USER billingapp WITH PASSWORD 'qwerty';
    
    -- Create the database with billingapp as the owner
    CREATE DATABASE billingapp_db OWNER billingapp;
EOSQL

# Connect to the new database and grant necessary privileges
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "billingapp_db" <<-EOSQL
    ALTER SCHEMA public OWNER TO billingapp;
    GRANT ALL PRIVILEGES ON DATABASE billingapp_db TO billingapp;
    GRANT ALL PRIVILEGES ON SCHEMA public TO billingapp;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO billingapp;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO billingapp;
EOSQL
