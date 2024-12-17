# Base image
FROM python:3.11-alpine

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Run OpenTelemetry bootstrap
RUN opentelemetry-bootstrap --action=install

# Copy the application code
COPY app.py .

# Expose the application port
EXPOSE 5000
