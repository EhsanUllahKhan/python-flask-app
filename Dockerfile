# Base image
FROM python:3.11-alpine

COPY . /python-flask-app

# Set work directory
WORKDIR /python-flask-app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run OpenTelemetry bootstrap
RUN opentelemetry-bootstrap --action=install

# Expose the application port
EXPOSE 5000
