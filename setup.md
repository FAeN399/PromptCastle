Document
Great — I'll generate a complete project starter kit for a new version of Prompt Castle. This will include a Dockerfile with precise environment setup, a version control and traceability guide, a completeness audit checklist, a developer Makefile, a testing strategy with AI prompt validation, and a CI/CD pipeline YAML file.

I'll gather everything needed to deliver this as a robust foundation for reproducible, testable, and maintainable prompt-based projects. I'll let you know once the full scaffold is ready.

# Prompt Castle 3.0 – Development & DevOps Scaffold

## Dockerfile ✅ (COMPLETED)

::: code Dockerfile

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

:::

> Note: The Dockerfile above is heavily commented for clarity. It installs system packages, Node.js 20.x (for any optional Node-based functionality), and Python dependencies from requirements.txt. The image uses Python 3.11 and Node 20 with specific versions pinned where possible. Usage instructions are provided as comments at the top of the file, showing how to build and run the container. The container runs the FastAPI app on port 8000 by default.

## requirements.txt ✅ (COMPLETED)

::: code text

# Python dependencies for Prompt Castle 3.0 (all version-pinned)

# Web framework and server:

fastapi==0.115.12 # FastAPI (Python web framework):contentReference[oaicite:0]{index=0}

uvicorn==0.34.3 # Uvicorn ASGI server for FastAPI

# CLI interface:

typer==0.16.0 # Typer for building CLI commands

# Database and ORM:

sqlmodel==0.0.21 # SQLModel for ORM (combines SQLAlchemy & Pydantic)

# LLM integration:

langchain==0.3.25 # LangChain for advanced prompt/LLM workflows

openai==1.83.0 # OpenAI Python SDK for API calls

# Testing and linting:

pytest==8.3.5 # PyTest for unit and integration tests

ruff==0.11.12 # Ruff linter for code quality (PEP8, etc.)

:::

> Note: Each dependency is pinned to a specific version for repeatable builds. Key frameworks include FastAPI (for the web API) and Typer (for the CLI). SQLModel is used for database models, combining the power of SQLAlchemy and Pydantic. LangChain and OpenAI SDK are included to facilitate LLM prompt engineering and API calls. Development tools like PyTest (for testing) and Ruff (for linting) ensure code quality.

## Version Control and Traceability Plan ✅ (COMPLETED - Documentation)

Effective version control practices will ensure that development is organized, changes are reviewed, and releases are well tracked. Below is a comprehensive plan covering branching, commit conventions, releases, issue traceability, and code reviews.

### Branching Strategy

Feature Branches: All feature development and bug fixes are done on dedicated branches created from the main branch (e.g. branches named feature/xyz-feature or bugfix/issue-123). This isolation keeps main clean and stable at all times, so the main branch never contains broken code (crucial for a healthy CI pipeline).
Pull Requests: Changes on feature branches are merged into main via pull requests (PRs) rather than direct pushes. This enables discussion and code review before integration. Each PR should remain focused on a single feature or fix, making it easier to review.
Main Branch Protection: The main branch will be protected: direct commits to main are disallowed. All merges to main must come from reviewed PRs. This guarantees that main only advances with approved, tested code (reducing risks of breaking the build on the main line).
### Commit Message Conventions

* **Conventional Commits:** We follow the **Conventional Commits** specification for all commit messages. Each commit message starts with a type (such as `feat`, `fix`, `docs`, `refactor`, etc.), an optional scope, and a short description. For example
feat(api): add castle generation endpoint
fix(cli): handle empty input error
These conventions make the purpose of each commit clear and feed into automated changelogs and versioning.

Issue References: Where applicable, commit messages should reference relevant issue IDs. According to the Conventional Commits spec, the commit footer can be used to reference issues (e.g. Refs #123 or Fixes #45). In practice, we often include the issue number in parentheses in the header for brevity, e.g. feat(api): add castle generation endpoint (#42). This practice ties commits to tracker items, aiding traceability.
### Tagging and Releases

Semantic Versioning: Releases will be tagged with version numbers following Semantic Versioning (SemVer) (e.g. v1.0.0, v1.1.0, v1.1.1, etc.). The version increments (major.minor.patch) reflect the significance of changes: major for breaking changes, minor for new features, patch for bug fixes. For example, after implementing new features without breaking existing APIs, we might tag v1.1.0.
Git Tags: A Git tag is created for each release. This snapshot of the repository at the release commit allows us to easily retrieve source code for that version and is used by CI to trigger deployment (including Docker image publishing on release tags). Using semantic tags in Git helps the team and users quickly understand the scope of changes in each release.
Release Documentation: Optionally, maintain a CHANGELOG that summarizes changes in each release (especially for external users). While not mandatory, a well-maintained changelog (or GitHub/GitLab release notes auto-generated from commits) can greatly improve transparency. Each tagged release can include notes (features added, bugs fixed) for traceability.
### Traceability to Issues

Issue-PR Linkage: Every pull request should be linked to a corresponding issue or user story. This can be done by referencing the issue number in the PR description (e.g. "Closes #123") or in commit messages. GitHub will automatically link and close issues if keywords like "Closes #123" or "Fixes #123" are used. Enforcing this practice ensures that no code change is done without a tracked reason. It provides end-to-end traceability: one can trace from a deployed change back to the initial issue/request that prompted it.
Workflow Enforcement: To reinforce this, we can adopt a policy (or even a CI check) that rejects PRs which don't reference an issue. This ensures compliance. Team culture should encourage opening an issue for any significant code change, even if discovered ad-hoc, so it can be tracked and discussed before implementation. This process helps in auditing changes and understanding why a change was made when looking back in the history.
### Code Reviews and Approvals

Peer Review: All code changes must go through peer review. At least one approval from another developer is required before a PR can be merged into main. Code review improves code quality, catches bugs, and spreads knowledge among the team. In settings with high criticality or larger teams, we might even require 2 approvals for extra safety, but at minimum one is enforced.
Review Process: Reviewers should check for code correctness, readability, adherence to style, and adequate testing. If changes are requested, the author should address them and get approval. We use GitHub's review feature to approve changes formally.
Branch Merging: Only after PR approval (and all CI checks passing) can the branch be merged. We use "Squash and Merge" or "Rebase and Merge" as appropriate to keep the commit history clean (squash for many tiny commits, rebase for linear history). Each merge commit (or squashed commit) on main will then typically correspond to a fully reviewed change set.
By adhering to this version control strategy, we ensure that every change is tracked, reviewed, tested, and tied to a purpose. This yields a highly traceable and maintainable project history, where we can audit what went into each release and why.

## Completeness Audit Checklist ⏳ (IN PROGRESS)

**Items to complete:**
- [x] README.md - Create a comprehensive README with installation, usage instructions and examples
- [x] CONTRIBUTING.md - Create guide for new contributors (if this will be open source)
- [x] LICENSE - Add appropriate license file
- [x] .gitignore - Ensure proper .gitignore file is in place
- [ ] CODE_OF_CONDUCT.md (Optional for open source projects)
- [ ] CHANGELOG.md (Optional if not using GitHub releases for tracking changes)

## Makefile ✅ (COMPLETED)

Below is a **Makefile** to streamline common development tasks. Using `make` targets allows quick execution of frequent commands (with the same behavior on all developer machines and CI)
::: code Makefile

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

:::

Targets explanation:

`make setup` – Installs the Python dependencies (from requirements.txt) into the current environment. This assumes you have a Python environment ready (you might run this inside the Docker container or within a Python virtualenv on your machine).
`make run` – Launches the FastAPI web server using Uvicorn. This will serve the app at [http://localhost:8000](http://localhost:8000) (useful for local development). The --reload flag is used so that the server auto-reloads on code changes (convenient during development; you might omit --reload in production). Adjust the host/port as needed; 0.0.0.0 makes it accessible from outside the container if running in Docker.
`make test` – Runs the test suite using PyTest. This will execute all tests in the tests/ directory (and any others discovered by pytest). It's a shorthand to ensure tests pass before committing or merging.
`make lint` – Runs the Ruff linter on the codebase. Ruff will check for code style issues, unused imports, etc. If it prints no output, that means the code is clean. (We could integrate automatic formatting or use Ruff's --fix in a separate target if desired.)
`make clean` – Cleans up any Python cache or artifact files. It removes __pycache__ directories, compiled .pyc files, pytest cache, coverage files, etc. This helps to ensure a clean working directory (for example, before packaging or when switching branches). This target is also handy to run before committing, to avoid committing any cache files by accident.
Each target is marked as .PHONY because they don't correspond to actual files; this ensures make will run them every time they are invoked. The @echo lines simply print a friendly message to the console (the @ prevents the echo command itself from being shown, for readability). The hyphen - in front of some commands (like -rm) allows the command to fail without stopping the Make (for example, if no __pycache__ exists, the rm would error; prefixing with - ignores that error).

Using this Makefile, developers and CI can perform routine actions with simple commands, ensuring consistency across environments.

## Test Strategy ✅ (COMPLETED - Documentation)

Our testing strategy covers multiple levels of the project to ensure robustness: unit tests for individual components, integration tests for the system as a whole (including CLI and API), and prompt regression tests to guard against unintended changes in prompt outputs. All tests should be automated via PyTest and integrated into CI for continuous validation.

### Unit Testing

Unit tests focus on small, isolated pieces of logic (functions or classes). For example, if Prompt Castle includes a parser for a custom prompt markup or "AML" (perhaps an Assistant Markup Language for prompts), we would write unit tests for that parser to ensure it handles all expected input cases.

*Example:* Suppose we have a function `parse_aml(text: str) -> dict` that parses a string in AML format into a Python dictionary. A unit test (in `tests/test_aml_parser.py`) might look like
::: code python

from promptcastle.parsing import parse_aml

def test_parse_simple_aml():

"""Test that a simple AML string is parsed correctly."""

aml_input = "USER: Hello\nASSISTANT: Hi there!" # hypothetical format

expected = {

"user": "Hello",

"assistant": "Hi there!"

}

result = parse_aml(aml_input)

assert result == expected

:::

This test is purely in-memory and does not depend on external systems. We would create similar unit tests for any critical function: e.g., prompt template rendering, utility functions, SQLModel models (you might test that model defaults or validations work), etc. Unit tests should cover edge cases (empty inputs, invalid inputs) to confirm the code handles errors gracefully.

Key practices for unit tests
Keep them fast and focused on logic (no network or database calls – use mocks or fakes if needed to isolate the unit).
Aim for high coverage on core modules (business logic, prompt formatting, etc.).
Use descriptive test function names and docstrings to clarify intent (as shown in the example).
### Integration Testing

Integration tests cover the interactions between components. In Prompt Castle, there are two main interfaces to test integratively: the CLI (Typer app) and the web API (FastAPI). These tests ensure that, for example, the FastAPI endpoints respond correctly and the CLI commands work as expected when run as a user would run them.

**FastAPI API Tests:** We use FastAPI's `TestClient` to simulate HTTP calls to our API endpoints. This does not require the server to run separately; `TestClient` can directly invoke the app in tests. For example, if our FastAPI app has an endpoint `/castle/{id}` that retrieves a castle prompt by ID, an integration test could be
::: code python

from fastapi.testclient import TestClient

from promptcastle.main import app # assuming the FastAPI instance is in main.py

client = TestClient(app)

def test_get_castle():

# Assuming we have a castle with ID 1 in test database or we seed one.

response = client.get("/castle/1")

assert response.status_code == 200

data = response.json()

assert data["id"] == 1

assert "prompt" in data # the response contains a prompt field

:::

This test spins up the app in testing mode and calls the endpoint, checking that we got a successful response and that the data structure is as expected. We might set up a test database or use SQLite with SQLModel for these tests (perhaps using an in-memory SQLite for speed). The key is to verify that the whole stack (routing, data layer, etc.) works together. Another example is testing authentication flows or error cases (requesting a nonexistent castle ID returns a 404, etc.).

**CLI Tests:** Typer makes it straightforward to test CLI commands by using the `CliRunner` from the Click library (Typer is built on Click). For example, if our CLI has a command `promptcastle generate --template basic`, an integration test for the CLI could be
::: code python

from typer.testing import CliRunner

from promptcastle.cli import app # assuming Typer app is defined in cli.py

runner = CliRunner()

def test_cli_generate():

result = runner.invoke(app, ["generate", "--template", "basic"])

assert result.exit_code == 0

output = result.stdout

assert "Generated prompt" in output # CLI outputs a confirmation

:::

This simulates a user running the promptcastle generate --template basic command and captures the output. We verify the command exits successfully and produces the expected text. We would write similar tests for other CLI commands (help text, error conditions, etc.).

Database and External Integration: If the application integrates with external services (e.g., calls OpenAI API via the openai library), integration tests should avoid hitting real external APIs. Instead, we can mock external calls. For instance, when testing a function that calls openai.ChatCompletion.create(), we can patch that method to return a predetermined response (so tests run offline and deterministically). This way, we still test our integration logic without relying on network calls.

### Prompt Regression Testing

One unique aspect of Prompt Castle is likely the generation and formatting of prompts. Prompt regression tests are intended to ensure that changes to the code do not unintentionally alter the prompts or chat flows that the system produces. This is important in applications that rely on specific prompt wording or structure for correct AI responses.

**Approach:** We maintain a set of sample prompt scenarios (input + expected output pattern) and verify the system's output against these. For example, we might have a YAML file `tests/prompt_tests.yml` with entries like
::: code yaml

- id: basic_greeting

input:

user_message: "Hello"

expected: "Hello, traveler! Welcome to Prompt Castle."

- id: help_flow

input:

user_message: "I need help"

expected_contains: "How can I assist" # substring expected in the assistant's reply

:::

In the test code, we load this YAML and for each case, feed the input to our system's prompt generation function or endpoint. Then we assert that the output meets the expectation. The expectation could be an exact match or a pattern/substring. Since AI outputs can be somewhat stochastic, we often don't check for 100% exact text, but rather key phrases or structural markers. For example, ensure the assistant's reply contains a certain sentence or starts with a greeting, etc.

By running these tests, if a developer changes the prompt template or logic, they will quickly see if a previously expected phrase disappeared or changed unintentionally. For instance, if a prompt was supposed to always include a certain disclaimer and a code change accidentally removed it, a prompt regression test would catch that difference.

Maintaining Prompt Tests: Whenever a prompt's expected output intentionally changes (e.g., we improved the phrasing), we update the test expectations accordingly. Keeping these tests up-to-date effectively creates a contract for the AI prompt outputs that the team agrees on.

### Continuous Integration (CI) Integration

All the above tests (unit, integration, and prompt regression) are run automatically in CI on every push or pull request. Our GitHub Actions workflow (detailed in the next section) will execute `make lint` and `make test`, which in turn run the linter and PyTest suite. This ensures that
No code gets merged that fails unit or integration tests. The CI will mark the build as failed if any test fails, preventing the PR from being merged until it's fixed.
The coding standards are maintained (if ruff finds an issue, the CI fails as well).
The team gets quick feedback after each commit about the health of the project.
Additionally, running tests in CI can be augmented with coverage reporting (to ensure we maintain or improve test coverage) and parallel test execution for speed (PyTest with xdist, etc., if the test suite grows large). For now, the straightforward approach ensures that by the time code is in the main branch, it has passed all checks and tests.

### Summary

In summary, our test strategy is comprehensive: each new feature or bug fix should include corresponding tests. We practice TDD (Test-Driven Development) where feasible – writing tests first or in parallel – to clarify requirements. The combination of unit tests (to catch issues in isolated logic), integration tests (to catch issues in the interplay of components or external integration), and regression tests (to catch changes in AI behavior or other outputs) gives us confidence in the stability of Prompt Castle. By automating these in CI, we catch issues early and ensure quality is maintained release over release.

## CI/CD Pipeline (GitHub Actions) ✅ (COMPLETED)

We use GitHub Actions to implement Continuous Integration (and an optional Continuous Delivery for Docker image releases). The CI pipeline runs on each push and pull request to the main branch, ensuring code quality and test passing before changes are merged. Additionally, when a version tag is pushed (indicating a new release), the pipeline can build and publish a Docker image for that release.

Below is a sample **GitHub Actions workflow file** (e.g., `.github/workflows/ci.yml`) that accomplishes these goals
::: code yaml

name: CI

# Run CI on pushes to main, pull requests into main, and version tags

on:

push:

branches: [ "main" ]

tags: [ "v..*" ] # Trigger on semantic version tags like v1.0.0

pull_request:

branches: [ "main" ]

jobs:

# Primary build and test job

build-and-test:

runs-on: ubuntu-latest

steps:

- name: Checkout source

uses: actions/checkout@v3

- name: Set up Python 3.11

uses: actions/setup-python@v4

with:

python-version: "3.11"

- name: Set up Node.js 20

uses: actions/setup-node@v3

with:

node-version: "20"

- name: Install dependencies

run: pip install -r requirements.txt

- name: Lint code

run: make lint # runs Ruff for style checks

- name: Run tests

run: make test # runs PyTest test suite

# Conditional job to build and push Docker image on releases

publish-image:

# Only run if the workflow was triggered by a version tag push

if: startsWith(github.ref, 'refs/tags/v')

needs: build-and-test # ensure tests passed before image build

runs-on: ubuntu-latest

steps:

- name: Checkout source

uses: actions/checkout@v3

- name: Set up Docker Buildx (for multi-arch, optional)

uses: docker/setup-buildx-action@v2

- name: Log in to Docker Registry

uses: docker/login-action@v2

with:

username: ${{ secrets.DOCKERHUB_USERNAME }}

password: ${{ secrets.DOCKERHUB_TOKEN }}

# ^^ Use GitHub Secrets for secure credentials

- name: Build and push Docker image

uses: docker/build-push-action@v3

with:

context: .

push: true

tags: ${{ secrets.DOCKERHUB_USERNAME }}/promptcastle:${{ github.ref_name }}

# This will tag the image as e.g. user/promptcastle:v1.0.0

:::

Workflow Explanation:

* The workflow is named
push to the main branch (e.g., merges or direct commits to main, though direct commits are discouraged by our process).
pull\_request events targeting the main branch (so every PR will run tests).
Pushes of Git tags matching the pattern v*.*.* (e.g., v1.2.0). This last trigger is for release tags, to kick off the Docker image build/publish.
Job: build-and-test: This job runs on the latest Ubuntu runner. It checks out the repository code, sets up Python 3.11 and Node 20 (matching our project requirements). Installing Node in CI ensures that if we had any Node-based build steps (for example, building a front-end or running a Node script), the environment can handle it. In this scaffold, we don't explicitly have such steps, but we include the setup to mirror the Docker environment (and future-proof if we add front-end tests). Then it installs Python dependencies using pip. After that, it runs make lint and make test – these will execute the Ruff linter and PyTest, respectively. If either the linting or tests fail, this job (and thus the workflow) will fail, blocking the PR or indicating a problem on main.
By having this job run on every PR, we ensure code quality (style and tests) before merging. Developers will see right in the PR if something needs fixing.

Job: publish-image: This job only runs when a tagged release is pushed (thanks to the if: startsWith(github.ref, 'refs/tags/v') condition). It has a dependency needs: build-and-test, meaning it waits for the first job to succeed. We only want to publish an image if tests passed. This job also uses Ubuntu and performs a checkout (we need the code to build the image). Then it sets up Docker Buildx – this is optional but recommended if you plan to build multi-architecture images (e.g., both linux/amd64 and arm64). It's harmless to include even for single-arch builds.
Next, it logs into the Docker registry. In this example, we show Docker Hub (docker/login-action), using secrets DOCKERHUB_USERNAME and DOCKERHUB_TOKEN which would be configured in the GitHub repo settings. (Alternatively, one could use GitHub Container Registry (GHCR) – the action would be similar, just different credentials and image name.)

Finally, the Build and push Docker image step uses Docker's official action to build the Dockerfile and push the image. We set context: . (build the current directory) and push: true. The tags field is set to tag the image with the version. We use ${{ github.ref_name }} which, for a tag event, is the tag name (like v1.2.0). So if your Docker Hub username is "myuser", this tags the image as myuser/promptcastle:v1.2.0. We could also add latest tag if we want to update a floating "latest" tag on each release. For example, we could include tags: myuser/promptcastle:${{ github.ref_name }}, myuser/promptcastle:latest to tag two names. That depends on the release strategy.

Security and best practices: We ensure no secrets are exposed in logs (the Docker login action masks the password). Also, note that this pipeline runs on PRs from forks as well – if so, GitHub by default will not inject secrets for security. That means the image publish job will simply not run for forked PRs (since there's no tag push in that case, it's fine). For internal pushes where we tag, secrets will be available and the image will publish.

CI Results: With this setup, every PR will show checks for linting and tests. Only after merging (or on pushing a tag) will the image publish occur. This separation ensures that only approved, reviewed, and tested code gets released in an image. If any step fails (lint or test), the workflow is marked failed, and the team can fix the issue before proceeding. This automates our quality gates and release process, reducing manual effort and error.

---

Clarity and Best Practices: The provided scaffold and plans emphasize maintainability and transparency. We've organized the content with clear headings and bullet points for readability, included in-line comments in configuration files (Dockerfile, Makefile, CI YAML) to explain the purpose of each step, and cited best-practice references for each approach. By following this scaffold, the Prompt Castle project's new version will have a solid foundation in both development and DevOps aspects, ensuring a smooth and professional workflow from code to deployment.&#x20;

