# Contributing to Prompt Castle

Thank you for considering contributing to Prompt Castle! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

Please review our [Code of Conduct](CODE_OF_CONDUCT.md) to understand the expectations for participation in our community.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in the [Issues](https://github.com/yourusername/promptcastle/issues).
2. If not, create a new issue with a clear description, including:
   - Steps to reproduce the bug
   - Expected behavior
   - Actual behavior
   - Screenshots (if applicable)
   - Environment details (OS, Python version, etc.)

### Suggesting Features

1. Check if the feature has already been suggested in the [Issues](https://github.com/yourusername/promptcastle/issues).
2. If not, create a new issue with a clear description of the feature and its potential benefits.

### Pull Requests

1. Fork the repository.
2. Create a new branch for your feature or bugfix: `git checkout -b feature/your-feature-name` or `git checkout -b fix/your-bugfix-name`.
3. Make your changes following the coding conventions below.
4. Add or update tests as needed.
5. Run tests to ensure they pass: `make test`.
6. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/) format.
7. Push to your fork.
8. Submit a pull request to the `main` branch.

## Branching Strategy

- `main`: Production-ready code. All PRs must be merged through reviewed pull requests.
- Feature branches: Use `feature/name` for new features and `fix/name` for bug fixes.

## Commit Message Conventions

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification. Each commit message should have a structured format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or improving tests
- `chore`: Changes to build process or auxiliary tools

Examples:
```
feat(api): add endpoint for prompt versioning
fix(cli): resolve issue with empty input handling
docs: update installation instructions
```

## Development Setup

1. Clone your fork:
   ```
   git clone https://github.com/yourusername/promptcastle.git
   cd promptcastle
   ```

2. Set up a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Run tests to ensure everything is working:
   ```
   $env:PYTHONPATH="."; python -m pytest
   ```

## Coding Conventions

- Follow PEP 8 style guidelines
- Use type hints for function parameters and return values
- Write docstrings for all functions, classes, and modules
- Keep functions focused on a single responsibility
- Use descriptive variable names

## Testing

- Write tests for all new features and bug fixes
- Ensure all tests pass before submitting a pull request
- Aim for high test coverage of your code

## Code Review Process

1. At least one maintainer must review and approve your pull request
2. CI checks must pass (tests, linting)
3. Your changes must be up-to-date with the latest main branch

Thank you for contributing to Prompt Castle! 