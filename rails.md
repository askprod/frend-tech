# Rails Core

Purpose: framework conventions, controllers, services.

Keep this file concise. Change it when Rails code, framework conventions, or tooling evolve.

## Current App

- Application module: `FrendTech`.
- Rails defaults: `config.load_defaults 8.1`.
- Ruby version: `3.4.8`.
- Database adapter: PostgreSQL via `pg`.
- Frontend stack: Hotwire, import maps, Tailwind CSS, Propshaft.
- Background jobs, cache, and cable use Solid Queue, Solid Cache, and Solid Cable in production.
- `app/services` exists for plain Ruby service objects. Rails loads it through Zeitwerk when files and constants follow Rails naming conventions.

## Rails Conventions

- Prefer the default Rails layout and naming conventions.
- Keep HTTP behavior in controllers.
- Keep persistence rules, associations, validations, and query scopes in models.
- Keep async work in Active Job.
- Use `app/services` for API clients, external integrations, or workflows that do not belong cleanly in a controller, model, job, or mailer.
- Do not add a generic service framework or base class unless the codebase proves it needs one.
- Keep services as plain Ruby objects with explicit dependencies and a small public API.
