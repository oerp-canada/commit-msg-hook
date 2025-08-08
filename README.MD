# OERP Commit Message Hook

A **pre-commit `commit-msg` hook** to enforce OERP’s Standard Operating Procedure for commit messages. This ensures all commits have a consistent, traceable format including task/ticket IDs, tags, module names, and commit descriptions.

## Features

- Validates commit message format:  
  `{T?}{Task/Ticket ID} [TAGs] module1, module2: short description`
- Requires a detailed commit description (body) after the subject line
- Prevents commits that don’t follow OERP SOP standards

## Commit Message Format

- {T?}{Task/Ticket ID} [TAGs] module1, module2: short description

### Examples

`12345 [IMP] sale: Improve sale order confirmation flow`

Fixed an issue where confirmation emails were delayed under certain conditions.

`T6789 [FIX, IMP] stock, purchase: Correct stock reservation bug and add new purchase validations`

Resolved reservation conflict causing incorrect stock levels. Added validations to prevent invalid purchases.

## Installation

Add this hook to your project’s `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/oerp-canada/commit-msg-hook
    rev: v1.0.0
    hooks:
      - id: commit-msg-format
```
Then install the hooks locally:

```bash
pre-commit install --hook-type commit-msg
```

Usage

After installation, the hook runs automatically when committing. If your commit message does not comply with the format, the commit will be blocked with an error message explaining the required format.