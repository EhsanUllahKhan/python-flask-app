# Base image
FROM python:3.11-alpine

# Copy the application code into the container
COPY . /python-flask-app

# Set the working directory
WORKDIR /python-flask-app

# Install Python dependencies
RUN pip install --no-cache-dir -r /python-flask-app/requirements.txt \
    && opentelemetry-bootstrap --action=install

# Make sure the script is executable
RUN chmod +x /python-flask-app/bin/run_app.sh

# Expose the application port
EXPOSE 5000
