#!/bin/bash
cd docker
chown -R 991:991 public
if [ -z "$SUPERUSER_USERNAME" ] || [ -z "$SUPERUSER_EMAIL" ]; then
        echo "Error: Missing required env vars! Superuser creation skipped."
        exit 1
else
    docker-compose run --rm web bundle exec rails db:setup
    docker-compose run --rm web bundle exec rails mastodon:make_admin USERNAME=$SUPERUSER_USERNAME EMAIL=$SUPERUSER_EMAIL
    docker-compose up 
fi