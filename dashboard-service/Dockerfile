FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY ergo-miningcore/dashboard /app/dashboard
COPY dashboard-service/run_dashboard.py /app/run_dashboard.py

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl procps \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH=/app/dashboard

EXPOSE 8888

CMD ["python", "/app/run_dashboard.py"]

