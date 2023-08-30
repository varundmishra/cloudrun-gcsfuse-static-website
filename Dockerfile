# Use the official Nginx image.
# https://hub.docker.com/_/nginx
FROM nginx:latest
COPY default.conf /etc/nginx/conf.d/

# Install cgsfuse and system dependencies
RUN apt-get update && apt-get install -y curl gnupg lsb-release tini && gcsFuseRepo=gcsfuse-`lsb_release -c -s` && \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add - && \
    apt-get update && \
    apt-get install -y gcsfuse && \
    apt-get clean

# Set fallback mount directory
ENV MNT_DIR /mnt/gcs

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container image.
COPY . ./

# Ensure the script is executable
RUN chmod +x /app/gcsfuse_run.sh

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Pass the wrapper script as arguments to tini
CMD ["/app/gcsfuse_run.sh"]