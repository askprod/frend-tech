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
