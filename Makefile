# Makefile for common development tasks

.PHONY: setup run test lint clean

setup:
	@echo "Installing Python dependencies..."
	pip install -r requirements.txt

run:
	@echo "Starting FastAPI server on http://localhost:8000"
	uvicorn main:app --reload --host 0.0.0.0 --port 8000

test:
	@echo "Running test suite..."
	pytest

lint:
	@echo "Running linter (Ruff)..."
	ruff .

clean:
	@echo "Cleaning up Python caches..."
	-find . -type d -name "__pycache__" -exec rm -rf {} +
	-find . -type f -name "*.pyc" -delete
	-rm -rf .pytest_cache .coverage coverage.xml 