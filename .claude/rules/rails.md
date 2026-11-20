---
paths:
  - "app/**/*.rb"
  - "config/**/*.rb"
  - "db/**/*.rb"
  - "lib/**/*.rb"
---

# Rails Rules

- Follow existing architecture; inspect existing patterns before introducing new ones.
- Prefer conventional Rails. No new service objects, abstractions, or gems for things that already exist.
- Active Record: use existing associations and scopes, avoid N+1 and unnecessary queries, keep validations and callbacks unless asked to change them.
- Controllers: keep existing conventions, authorization, authentication, and response formats. No unrelated refactoring.
- Views: reuse existing components and helpers. No new frontend frameworks. Make only the UI changes the task needs.
- Migrations: reversible, safe for existing records. Never drop columns or tables without explicit approval, and never assume a migration is safe just because it works locally.
