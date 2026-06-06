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
- Put external API clients under `app/services/apis`. Shared HTTP behavior belongs in `Apis::BaseClient`; provider-specific clients live in provider namespaces such as `Apis::XAPI`.
- When adding service classes, include a simple nearby `README.md` that explains the service classes and minimal usage examples.
- Prefer compact constant definitions over nested module blocks, for example `class Apis::XAPI::Posts`.
- Keep `attr_reader`, `attr_accessor`, and similar declarations at the top of the class.
- Put a blank line after visibility keywords such as `private`, and keep the following methods aligned with other method definitions instead of adding an extra indentation level.
- Use the `rest-client` gem for outbound HTTP calls.
- Use `bin/rails credentials:edit_with_cursor` to edit Rails credentials in Cursor without setting `EDITOR` manually. Pass an environment with `bin/rails "credentials:edit_with_cursor[production]"`.
- API secrets are stored in environment-scoped Rails credentials under `<environment>.x_api.api_key`, `<environment>.x_api.secret_key`, and `<environment>.x_api.bearer_token`.
- Do not add a generic service framework or base class unless the codebase proves it needs one.
- Keep services as plain Ruby objects with explicit dependencies and a small public API.
