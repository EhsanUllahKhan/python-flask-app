#!/bin/bash

OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true \
OTEL_EXPORTER_OTLP_ENDPOINT=ingest.us.signoz.cloud:443 \
OTEL_EXPORTER_OTLP_HEADERS=signoz-ingestion-key=e8cfe77c-b82a-4022-91fe-b81eb2b48700 \
opentelemetry-instrument --traces_exporter otlp --metrics_exporter otlp --logs_exporter otlp python app.py
