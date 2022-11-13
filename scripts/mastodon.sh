#!/bin/bash

cd docker
chown -R 991:991 public
if [ -z "$SUPERUSER_USERNAME" ] || [ -z "$SUPERUSER_EMAIL" ] || [ -z "$SUPERUSER_PASSWORD" ]; then
        echo "Error: Missing required env vars! Superuser creation skipped."
        exit 1
else
    # Create and migrate the database.
    docker-compose run --rm web bundle exec rails db:setup
    # Create admin user with given email
    RAILS_ENV=production docker-compose run --rm web bundle exec rails r superusers/create_superuser.rb 
    # Up all containers
    docker-compose up
fi