# Dockerfile for Prompt Castle 3.0
# Usage:
# Build the image:
# docker build -t promptcastle:latest .
# Run an interactive container:
# docker run --rm -it promptcastle:latest bash
# Run the FastAPI app (detached, accessible on port 8000):
# docker run -d -p 8000:8000 promptcastle:latest
#
# The image is based on Python 3.11 with Node.js 20.x included for optional frontend tasks.
# Use official Python 3.11 slim image (Debian Bullseye), pinned to a specific version for reproducibility
FROM python:3.11.12-slim-bullseye

# Set a working directory for the app
WORKDIR /app

# Install system dependencies:
# - curl, gnupg: for adding NodeSource repository
# - build-essential: compilers for building Python packages (if needed)
# - (Node.js will be installed via NodeSource script)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    build-essential \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Python dependency list and install them (with version pins for consistency)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# (Optional) Create a non-root user for running the app securely
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Expose the FastAPI port
EXPOSE 8000

# Default command: launch the FastAPI app with Uvicorn (adjust the module/app name as needed)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"] 