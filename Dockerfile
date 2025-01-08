# Use official Python 3.9 image as a base
FROM python:3.9-slim

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    wget \
    curl \
    unzip \
    ca-certificates \
    libx11-dev \
    libxcomposite1 \
    libxrandr2 \
    libglu1-mesa \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libgdk-pixbuf2.0-0 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libxss1 \
    xdg-utils \
    libappindicator3-1 \
    libx11-xcb1 \
    fonts-liberation \
    libu2f-udev \
    libnss3-tools \
    libasound2 \
    libvulkan1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (latest stable)
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome.deb \
    && dpkg -i google-chrome.deb \
    && apt-get install -f -y \
    && rm google-chrome.deb

# Install ChromeDriver using webdriver-manager
RUN pip install webdriver-manager

# Set environment variable to disable headless errors (render doesn't need this for headless)
ENV DISPLAY=:99

# Set working directory
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the necessary port for the app
EXPOSE 8080

# Command to run the application using Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8080"]
