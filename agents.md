# AGENTS.md

## Context Map

RAILS_CORE:
- path: ./rails.md
- purpose: framework conventions, controllers, services

BUSINESS_LOGIC:
- path: ./business.md
- purpose: product rules, workflows, constraints

DOMAIN_MODELS:
- path: ./models.md
- purpose: entities, relationships, validations

## Loading Strategy

- For implementation tasks -> RAILS_CORE + DOMAIN_MODELS
- For product decisions -> BUSINESS_LOGIC
- For debugging -> all modules

## Documentation Rules

- Keep all module files concise.
- Change the relevant module file when the code evolves.
- Remove stale guidance when it no longer matches the codebase.

## Commit Messages

- Use semantic commit messages: `<type>(<scope>): <subject>`.
- Scope is optional; write the subject as a present-tense summary.
- Supported types: `chore`, `docs`, `feat`, `fix`, `refactor`, `style`, and `test`.
- Reference: https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716
