# Use Python 3.10 as the base image (slim for lightweight)
FROM python:3.10-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies for Chrome, Selenium, and scraping
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    ca-certificates \
    libx11-xcb1 \
    libgdk-pixbuf2.0-0 \
    libdbus-glib-1-2 \
    libxtst6 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxcomposite1 \
    libxrandr2 \
    libsecret-1-0 \
    fonts-liberation \
    libappindicator3-1 \
    libnspr4 \
    libnss3 \
    xdg-utils \
    && apt-get clean

# Install Google Chrome stable version
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -f -y

# Install ChromeDriver (make sure to match the version of Chrome)
RUN LATEST_CHROMEDRIVER=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget https://chromedriver.storage.googleapis.com/$LATEST_CHROMEDRIVER/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver

# Set environment variables for Chrome and WebDriver
ENV PATH="/usr/local/bin:${PATH}"
ENV GOOGLE_CHROME_BIN="/usr/bin/google-chrome"
ENV CHROME_DRIVER="/usr/local/bin/chromedriver"

# Set the working directory to /app (where your Python app will reside)
WORKDIR /app

# Copy the application files into the container
COPY . /app/

# Install Python dependencies from requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Install Gunicorn to serve the app
RUN pip install gunicorn

# Expose the port for Gunicorn (Render will expose port 10000 by default)
EXPOSE 10000

# Command to run your app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]
