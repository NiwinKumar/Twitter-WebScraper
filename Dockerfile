# Use official Ubuntu as a parent image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies and utilities
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    sudo \
    ca-certificates \
    && apt-get clean

# Download and convert the PGP key to GPG format
RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
    gpg --dearmor -o /usr/share/keyrings/elastic-7.x.gpg

# Add the Elasticsearch repository with the GPG key and specify it in the repository configuration
RUN echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/elastic-7.x.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | \
    tee /etc/apt/sources.list.d/elastic-7.x.list

# Update the apt repository and install Elasticsearch
RUN apt-get update && apt-get install -y \
    elasticsearch \
    && apt-get clean

# Expose the necessary ports for Elasticsearch
EXPOSE 9200 9300

# Set the default command to run Elasticsearch
CMD ["elasticsearch"]
