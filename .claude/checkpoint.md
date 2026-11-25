# Refactor checkpoint

Suggested order of work. `(#n)` is the item number from the 2026-11-25 refactor report (sorted smallest first there).
Tick items off as they land. `[schema]` = needs a migration, so ask before running.

## Phase 1: quick wins (security, cheap query fixes)
- [x] 1. (#3) `QueuedPicksController#update_order`: remove raw SQL interpolation of ids (SQL injection); scope to current user's queue
- [ ] 2. (#1) `DisplayCardsController#route`: replace `participant_picks.map(&:cube_card).include?` with `exists?`; memoize `active_participant`
- [ ] 3. (#2) `ParticipantPick#availability`: single `exists?` query, only when `cube_card_id` changed
- [ ] 4. (#7) `DraftListComponent`: replace Ruby array subtraction with `where.not(id: ...)`
- [ ] 5. (#5) Extract shared business-day check from `TimerCalculator` and `TransferPortalTransaction`
- [ ] 6. (#4) `Cube::Display#sort_land`: rule list + single sort key, nil-safe `card_text`; drop `define_method` loop

## Phase 2: draft core (correctness and pick performance)
- [ ] 7. (#8) Track current pick on `drafts` (e.g. `current_pick_number`) or memoize; remove repeated `active_pick`/`last_pick_number` queries [schema if column added]
- [ ] 8. (#10) Extract `Drafts::MakePick` (and `Drafts::SkipActivePick`) service; wrap in `with_lock`; enqueue jobs after commit; dedupe "email next user"
- [ ] 9. (#9) Add `draft_id` to `participant_picks` + unique `(draft_id, cube_card_id)` index; simplify joins; closes the double-pick race [schema]

## Phase 3: render and broadcast cost (biggest runtime win on a small host)
- [ ] 10. (#14) Replace full-page `Broadcast::DraftUpdateJob` re-render with per-pick Turbo Stream updates
- [ ] 11. (#15) Split draft page into Turbo Frames (pick grid, cube list, timer)
- [ ] 12. (#13) Slim `MagicCardContext`: drop `precompute_draft_data`; replace per-render `maximum(:updated_at)` cache-key query with a stored timestamp [schema if column added]

## Phase 4: infrastructure and housekeeping
- [ ] 13. (#6) Drop redundant/unused indexes (verify with `pg_stat_user_indexes` first) [schema]
- [ ] 14. (#16) Redis `maxmemory` + eviction policy, separate cache DB, Puma thread count, jemalloc / `MALLOC_ARENA_MAX`

## Phase 5: larger, needs decisions
- [ ] 15. (#12) Batch cube import (`insert_all`, name-indexed lookups), move to a Sidekiq job; decide the `count` vs one-row-per-copy semantics; check whether `CardEnricher` is unused and delete it [schema maybe]
- [ ] 16. (#11) Replace per-pick scheduled skip/auto-pick jobs with a periodic sweep (only if Redis memory is a problem; needs a cron gem, approval required)
- [ ] 17. (#17) Data model cleanup: `cube_cards.custom_*`/`count` duplication, dual `skipped` flags, string enums, unused `surrogate_user_id`, nullable `transfers_allowed` [schema]

## Notes
- Items 7-9 are linked: do 7 before 8, and 9 finishes the race fix started in 3.
- Item 12 depends on 7.
- Item 11 should follow 10 so frames can be targeted by the new broadcasts.
