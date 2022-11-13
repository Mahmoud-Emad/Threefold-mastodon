#!/bin/bash
cd docker
chown -R 991:991 public
if [ -z "$SUPERUSER_USERNAME" ] || [ -z "$SUPERUSER_EMAIL" ]; then
        echo "Error: Missing required env vars! Superuser creation skipped."
        exit 1
else
    # Create and migrate the database.
    docker-compose run --rm web bundle exec rails db:setup
    # Create admin user with given email
    result=$(RAILS_ENV=production docker-compose run --rm web bin/tootctl accounts create $SUPERUSER_USERNAME --email $SUPERUSER_EMAIL --confirmed --role Owner)
    # Get the password of created account then save it into .env.production
    SUPERUSER_PASSWORD=$(echo $result | awk -F: '{print $2}')
    echo SUPERUSER_PASSWORD=$SUPERUSER_PASSWORD | sed 's/ //g' >> .env.production
    # Up all containers
    docker-compose up 
fi
# rails --tasks