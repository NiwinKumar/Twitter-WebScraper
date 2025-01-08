# Use the Playwright Python base image with Edge support
FROM mcr.microsoft.com/playwright/python:v1.29.0

# Install necessary system dependencies
RUN apt-get update -y && \
    apt-get install -y \
    wget \
    curl \
    unzip \
    ca-certificates \
    gnupg2 \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libindicator7 \
    libnspr4 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add Microsoft Edge repository and install Edge
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl -sSL https://packages.microsoft.com/repos/edge/deb stable main | tee /etc/apt/sources.list.d/microsoft-edge.list && \
    apt-get update -y && \
    apt-get install -y microsoft-edge-stable

# Install dependencies for Python and your application
WORKDIR /app

# Copy the requirements.txt to the container and install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Set up environment variable for Python (Optional based on your app)
ENV PYTHONUNBUFFERED 1

# Copy your Python app files into the container
COPY . .

# Expose any necessary port for your app (Optional, based on your use case)
EXPOSE 8080

# Run the app using the specified CMD or ENTRYPOINT
CMD ["python", "twitter_scraper.py"]
