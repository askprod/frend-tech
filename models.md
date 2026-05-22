# Domain Models

Purpose: entities, relationships, validations.

Keep this file concise. Change it when persisted entities, relationships, validations, or database constraints evolve.

## Current Model State

- `ApplicationRecord` is the only model class currently present.
- No concrete domain models exist yet.
- No migrations exist yet.
- No `db/schema.rb` exists yet.

## Model Rules

- Document only models that exist in the codebase.
- When adding a model, document its purpose, relationships, validations, and important database constraints.
- Keep persistence behavior in models when it belongs to one record type.
- Use database constraints for invariants that must never be violated.
