# Use the official Python 3.11 slim image as the base image
FROM python:3.12-slim AS builder

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    musl-dev \
    libc-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /src/
RUN pip install --upgrade pip
RUN pip install --user -r /src/requirements.txt --no-cache-dir

FROM python:3.12-slim
# Copy only runtime dependencies
COPY --from=builder /root/.local /root/.local

ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/src

WORKDIR /src
COPY ./app /src

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]