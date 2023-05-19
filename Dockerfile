FROM ubuntu:latest

# Install software dependecies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg2 \
        apt-transport-https \
        ca-certificates \
        curl \
        python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install google-cloud-cli

# Copy the downloader script
COPY download_snapshot.sh /etc/lotus/docker/

# Use the script as an entry point
ENTRYPOINT [ "bash", "/etc/lotus/docker/download_snapshot.sh" ]
