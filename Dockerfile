# Use Python 3.10 as the base image (slim for lightweight)
FROM python:3.10-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies for Edge, Selenium, and scraping
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
    && apt-get clean

# Download and install Microsoft Edge stable version
RUN wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_115.0.1901.183-1_amd64.deb
RUN dpkg -i microsoft-edge-stable_115.0.1901.183-1_amd64.deb
RUN apt-get install -f -y

# Download and install the matching version of Edge WebDriver
RUN wget https://msedgedriver.azureedge.net/115.0.1901.183/edgedriver_linux64.zip
RUN unzip edgedriver_linux64.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/msedgedriver

# Set environment variable for the WebDriver path (EdgeDriver)
ENV PATH="/usr/local/bin:${PATH}"

# Set the working directory to /app (where your Python app will reside)
WORKDIR /app

# Copy the application files into the container
COPY . /app/

# Install Python dependencies from requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose port if your app is a web service (e.g., Flask, FastAPI)
EXPOSE 5000

# Command to run your Python app (make sure app.py is your entry point)
CMD ["python", "app.py"]
