FROM elasticsearch:8.19.2

# Switch to root temporarily
USER root

# Copy entrypoint and role definitions into container
COPY entrypoint.sh /entrypoint.sh
COPY roles /roles

RUN chmod +x /entrypoint.sh

# Switch back to elasticsearch user (default in base image)
USER elasticsearch

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
