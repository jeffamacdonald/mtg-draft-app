# MTG Draft App

Rails app for Magic: The Gathering rotisserie drafts (personal project, shared with friends; may be opened to others later). Goal: lower memory usage so it runs smoothly on a small, free host.

## Stack
Ruby 3.3.0, Rails, PostgreSQL (`pg_search`), Puma, Sidekiq + Redis, Turbo + Stimulus, ViewComponent (`app/components`), RSpec + factory_bot, annotaterb, RuboCop (`rubocop-rails-omakase`). Docker (`Dockerfile`, `Dockerfile.dev`) and Kamal for deploy.

Likely deploy target: Oracle Cloud free tier (size/RAM not yet decided; assume small, possibly ARM). Keep memory use low.

## Commands
- No local DB: run everything in Docker (`docker-compose.yml`: `web`, `sidekiq`, `pg`, `redis`).
- Lint: a PostToolUse hook runs RuboCop on each edited `.rb` file (report-only, via Docker `web`). Fix offenses in lines I changed; don't mass-fix legacy offenses.
- Tests: `docker compose exec -e RAILS_ENV=test web bundle exec rspec [path[:line]]` (services must be up)

## Priorities
Correctness, maintainability (human-readable code, consistent patterns), minimal changes, low token usage.

## Working Rules
- Start from the task; find the minimum relevant files with targeted `rg` searches. Never explore the whole codebase unless asked.
- Don't read `node_modules`, `vendor`, `log`, `tmp`, `storage`, compiled assets, or dependency source unless necessary. Don't reread files or repeat commands that already gave an answer.
- Keep command output short. Don't rerun failed commands without changing the approach; if blocked, stop and explain.
- Smallest change that solves the problem. Follow existing conventions and architecture. No unrelated refactoring, rewrites for style, or unnecessary abstractions/callbacks/concerns/service objects.
- Preserve existing behavior, authorization, validation, and error handling unless the task changes them.
- Ask before expanding scope.

## Conventions (going forward)
The codebase is old and doesn't fully match these; apply them to new/changed code, don't rewrite legacy code to match.
- Business logic lives in service classes, namespaced by model (e.g. `Drafts::AdvancePick`), not in model classes. Models keep associations, validations, scopes.
- Small stateless shared helpers that don't belong to one model (e.g. `BusinessDays.off?`) are plain modules/classes in `app/models/`.
- Frontend: use ViewComponent components and Turbo (frames/streams) before reaching for custom JavaScript.
- When a task needs a new pattern or convention not covered here, stop and ask the user's preference, then record the answer in this section.

## Approvals Required
- Installing, removing, or upgrading gems (and touching `Gemfile.lock`).
- Destructive or irreversible DB work: drop/reset/recreate, destructive migrations. Never touch production data or run migrations against production.
- Git: never discard uncommitted changes; no reset, rebase, or force-push; don't commit or push unless asked.
- Using Opus.

## Subagents
Only when delegation clearly saves usage (independent, narrow task a cheaper model can do and I can cheaply validate). Never for routine edits, simple fixes, or simple commands. No overlapping agents, no agent teams. I validate all delegated work.

## Task Flow
Brief plan only for multi-file or architectural work → smallest change → targeted tests → review the final diff → concise report (files changed, tests run and results, unresolved issues/risks).
