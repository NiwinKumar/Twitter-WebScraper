# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install dependencies for running Selenium and Microsoft Edge (Edge + WebDriver)
RUN apt-get update && apt-get install -y \
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
    --no-install-recommends

# Install Microsoft Edge
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" && \
    sudo apt-get update && \
    sudo apt-get install microsoft-edge-stable

# Install dependencies from requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files into the container
COPY . /app

# Expose the port the app runs on
EXPOSE 5000

# Set the environment variable to indicate no interactive mode
ENV PYTHONUNBUFFERED 1

# Define the command to run your app using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
