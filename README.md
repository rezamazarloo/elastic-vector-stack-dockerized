# elasticsearch and kibana with docker-compose

this is a simple project to run elasticsearch and kibana with docker-compose.

## setup (development)

in first time we have to run docker services with setup profile to generate encryption keys for kibana and create our custom roles and users.

- generate encryption keys: run `docker compose run --rm kibana-keygen` to create KIBANA_SECURITY_ENCRYPTION_KEY, KIBANA_SAVED_OBJECTS_ENCRYPTION_KEY, KIBANA_REPORTING_ENCRYPTION_KEY and manually set in .env file.
- create custom role and users: run `docker compose up --build es-setup && docker compose down` to change default kibana_system user password and create custom role and users in elasticsearch for backend and vector. (if any error occurs use `docker compose down -v` to remove volumes and elasticsearch data and try again)

## run (development)

after setup is done, we can run the project with `docker compose up -d --build` command to load up elasticsearch and kibana services.

## setup (production)

in production `xpack.security.enabled: true` must be set so authentication and ssl be enabled also we must create ssl and define in setting otherwise cluster nodes refuse to connect to each other (exit code 78).

- generate encryption keys: run `docker compose -f docker-compose.prod.yml run --rm kibana-keygen` to create KIBANA_SECURITY_ENCRYPTION_KEY, KIBANA_SAVED_OBJECTS_ENCRYPTION_KEY, KIBANA_REPORTING_ENCRYPTION_KEY and manually set in .env file.
- cert generation: we must create 2 types of certificates a unique cert fo each node for node to node communication (xpack.security.transport) and a common cert (ca which is shared) for http communication (xpack.security.http). to do so run `docker compose -f docker-compose.prod.yml run --rm elasticsearch-certgen`.
- create custom role and users: run `docker compose -f docker-compose.prod.yml up --build es-setup && docker compose -f docker-compose.prod.yml down` to change default kibana_system user password and create custom role and users in elasticsearch for backend and vector. (if any error occurs use `docker compose -f docker-compose.prod.yml down -v` to remove volumes and elasticsearch data and try again)

## run (production)

after setup is done, we can run the project with `docker compose -f docker-compose.prod.yml up -d --build` command to load up elasticsearch cluster and kibana services.

## notice

- if you see `Network elk-with-docker-compose_elknet  Resource is still in use` error, you can remove the network and containers with `docker compose down --volumes --remove-orphans` command.

- to add kibana HTTPS support we have to generate cert also for kibana in cert-config.yml and add the following lines to kibana.yml:

```yaml
server.ssl.enabled: true
server.ssl.certificate: /usr/share/kibana/config/certs/kibana.crt
server.ssl.key: /usr/share/kibana/config/certs/kibana.key
  ```
