# elasticsearch and kibana with docker-compose

this is a simple project to run elasticsearch and kibana with docker-compose.

## setup (development)

in first time we have to run docker services with setup profile to generate encryption keys for kibana and create our custom roles and users.

- generate encryption keys: run `docker compose up kibana-keygen` to create KIBANA_SECURITY_ENCRYPTION_KEY, KIBANA_SAVED_OBJECTS_ENCRYPTION_KEY, KIBANA_REPORTING_ENCRYPTION_KEY and manually set in .env file.
- create custom role and users: run `docker compose up --build es-setup && docker compose down` to change default kibana_system user password and create custom role and users in elasticsearch for backend and vector. (if any error occurs use `docker compose down -v` to remove volumes and elasticsearch data and try again)

## run (development)

after setup is done, we can run the project with `docker compose up -d` command to load up elasticsearch and kibana services.
