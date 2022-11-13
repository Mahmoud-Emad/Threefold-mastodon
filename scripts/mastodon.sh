#!/bin/bash

script="
username = '$SUPERUSER_USERNAME'
password = '$SUPERUSER_PASSWORD'
email = '$SUPERUSER_EMAIL'

account = Account.create!(username: 'username')
user = User.create!(email: 'email', password: 'password', account: account)
user.confirm
account.save!
user.save!
"

cd docker
chown -R 991:991 public
if [ -z "$SUPERUSER_USERNAME" ] || [ -z "$SUPERUSER_EMAIL" ] || [ -z "$SUPERUSER_PASSWORD" ]; then
        echo "Error: Missing required env vars! Superuser creation skipped."
        exit 1
else
    # Create and migrate the database.
    docker-compose run --rm web bundle exec rails db:setup
    # Create admin user with given email
    RAILS_ENV=production docker-compose run --rm web bundle bash -c "printf \"$script\" | exec rails c"

    # Up all containers
    docker-compose up
fi
# rails --tasks