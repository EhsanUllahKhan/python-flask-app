#!/bin/bash

OTEL_RESOURCE_ATTRIBUTES=service.name=test-flask \
OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" \
OTEL_EXPORTER_OTLP_PROTOCOL=grpc opentelemetry-instrument python app.py
