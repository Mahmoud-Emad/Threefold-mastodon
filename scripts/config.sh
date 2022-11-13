#!/bin/sh

DOCKER_DIR=../docker/
SCRIPTS_DIR=../scripts/
ENV_DIR=${DOCKER_DIR}.env.production

exec |
	# Touch the .env.production file
	touch ${ENV_DIR}
	
	# SECRET_KEY_BASE, OTP_SECRET, VAPID_PRIVATE_KEY, VAPID_PUBLIC_KEY 
	# should be auto generated by excuting a command inside docker-compose.yaml file.
	echo $(cd ${DOCKER_DIR} && docker-compose run --rm web bundle exec rake mastodon:webpush:generate_vapid_key) >  ${ENV_DIR}
	echo SECRET_KEY_BASE=$(cd ${DOCKER_DIR} &&  docker-compose run --rm web bundle exec rake secret) >>  ${ENV_DIR}
	echo OTP_SECRET=$(cd ${DOCKER_DIR} &&  docker-compose run --rm web bundle exec rake secret) >>  ${ENV_DIR}

	# Single user mode, it will be by defualt > false, 
	# change it if you want to test it in a single user mode "it will skip the registration steps." 
	cd ${SCRIPTS_DIR} && echo 'SINGLE_USER_MODE'=false >> ${ENV_DIR}

	# # User SSH Pub key
	echo 'SSH_KEY'=$SSH_KEY >> ${ENV_DIR}

	# Local domain to use it.
	echo 'LOCAL_DOMAIN'=$LOCAL_DOMAIN >> ${ENV_DIR}

	# STMP Mail Server Conf.
	echo 'SMTP_SERVER'=$SMTP_SERVER >> ${ENV_DIR}
	echo 'SMTP_PORT'=$SMTP_PORT >> ${ENV_DIR}
	echo 'SMTP_LOGIN'=$SMTP_LOGIN >> ${ENV_DIR}
	echo 'SMTP_PASSWORD'=$SMTP_PASSWORD >> ${ENV_DIR}
	echo 'SMTP_FROM_ADDRESS'=$SMTP_FROM_ADDRESS >> ${ENV_DIR}
	echo 'SMTP_AUTH_METHOD'=$SMTP_AUTH_METHOD >> ${ENV_DIR}
	echo 'SMTP_OPENSSL_VERIFY_MODE'=none >> ${ENV_DIR}
	echo 'SMTP_DELIVERY_METHOD'=smtp >> ${ENV_DIR}
	echo 'SMTP_SSL'=true >> ${ENV_DIR}
	echo 'SMTP_ENABLE_STARTTLS_AUTO'=false >> ${ENV_DIR}
	echo 'SMTP_FROM_ADDRESS'="Mastodon <notifications@${LOCAL_DOMAIN}>" >> ${ENV_DIR}

	# Admin cerds.
	echo 'SUPERUSER_USERNAME'=$SUPERUSER_USERNAME >> ${ENV_DIR}
	echo 'SUPERUSER_EMAIL'=$SUPERUSER_EMAIL >> ${ENV_DIR}
	echo 'SUPERUSER_PASSWORD'=$SUPERUSER_PASSWORD >> ${ENV_DIR}

	# Redis conf.
	echo 'REDIS_HOST'=redis >> ${ENV_DIR}
	echo 'REDIS_PORT'=6379 >> ${ENV_DIR}
	echo 'REDIS_PASSWORD'= >> ${ENV_DIR}

	# PostgreSQL conf.
	echo 'DB_HOST'=db >> ${ENV_DIR}
	echo 'DB_PORT'=5432 >> ${ENV_DIR}
	echo 'DB_NAME'=postgres >> ${ENV_DIR}
	echo 'DB_USER'=postgres >> ${ENV_DIR}
	echo 'DB_PASS'= >> ${ENV_DIR}
	echo 'IP_RETENTION_PERIOD'=31556952 >> ${ENV_DIR}
	echo 'SESSION_RETENTION_PERIOD'=31556952 >> ${ENV_DIR}
	# Remove any space of start of lines 
	exec sed -i 's/ //g' ${ENV_DIR}
