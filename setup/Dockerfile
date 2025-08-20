FROM elasticsearch:8.19.2

# Switch to root temporarily
USER root

# Copy entrypoint and role definitions into container
COPY entrypoint.dev.sh /entrypoint.dev.sh
COPY entrypoint.prod.sh /entrypoint.prod.sh

COPY roles /roles

RUN chmod +x /entrypoint.dev.sh /entrypoint.prod.sh

# Switch back to elasticsearch user (default in base image)
USER elasticsearch
