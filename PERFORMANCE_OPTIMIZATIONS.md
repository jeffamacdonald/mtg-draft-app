# Draft Show Page Performance Optimizations

## Overview
This document outlines the major N+1 query issues that were identified and fixed in the draft show page to improve loading performance.

## Major Performance Issues Fixed

### 1. **Draft Controller - Deep Includes for Participant Picks**
**Problem**: The original `find_draft` method only included basic associations, causing N+1 queries when rendering picks with color identity information.

**Solution**: Added deep includes for the complete association chain:
```ruby
participant_picks: [
  :draft_participant,
  { cube_card: { card: :color_identity } }
]
```

### 2. **MagicCardContext - Precomputed Data**
**Problem**: The `picked_cube_card_ids` method was calling `pluck` on every check, and `active_participant` was making repeated database calls.

**Solution**: Precompute expensive operations in the initializer:
- Use `Set` for O(1) lookup performance on picked cards
- Calculate active participant from already loaded data
- Avoid additional database queries by using in-memory data

### 3. **Draft Model - Memoization of Expensive Calculations**
**Problem**: `active_pick`, `active_participant`, and `last_pick_number` were making repeated database queries.

**Solution**: Added memoization with `@instance_variables` to cache results:
```ruby
def active_pick
  @active_pick ||= participant_picks.find_by(pick_number: last_pick_number + 1)
end
```

### 4. **PickListComponent - Optimized Data Access**
**Problem**: The template was calling `draft.participant_picks.order(:pick_number).group_by(&:round)` which ignored preloaded data.

**Solution**: 
- Added helper methods that use already loaded associations
- `grouped_picks_by_round` uses in-memory sorting and grouping
- `ordered_participants` uses pre-sorted data

### 5. **Cube Cards Loading - Color Identity Includes**
**Problem**: Loading cube cards without color identity caused N+1 when rendering cards.

**Solution**: Added `includes(card: :color_identity)` to preload the full chain.

### 6. **Counter Cache for Participants**
**Problem**: `draft.draft_participants.count` was making database calls for participant counting.

**Solution**: 
- Added `participants_count` column to drafts table
- Updated associations to maintain counter cache
- Replaced `.count` calls with counter cache attribute

### 7. **Database Indexes for Performance**
**Problem**: Missing indexes on frequently queried columns.

**Solution**: Added composite indexes for:
- `participant_picks` on `[draft_participant_id, pick_number]`
- `participant_picks` on `[cube_card_id, round]`
- `draft_participants` on `[draft_id, draft_position, skipped]`
- `cube_cards` on `[cube_id, soft_delete, custom_cmc]`

### 8. **Optimized Draft Loading Scope**
**Problem**: Repeating the same complex includes across different parts of the application.

**Solution**: Created `Draft.with_full_associations` scope that includes all necessary associations for draft display pages.

### 9. **Set Data Structure for O(1) Lookups**
**Problem**: Using Array for picked card lookups resulted in O(n) performance.

**Solution**: Used Ruby's Set class for O(1) lookup performance when checking if cards are picked.

## Performance Impact

### Before Optimizations:
- Multiple N+1 queries for each participant pick (could be 100+ picks per draft)
- Repeated database calls for active participant calculation
- Unindexed queries on frequently accessed columns
- Database counts instead of cached values

### After Optimizations:
- Single query loads all required data with proper includes
- In-memory calculations using preloaded data
- Indexed queries for faster lookups
- Counter cache eliminates count queries

## Files Modified

1. **app/controllers/drafts_controller.rb**
   - Enhanced `find_draft` includes
   - Added color identity to cube cards query

2. **app/models/magic_card_context.rb**
   - Precompute expensive operations
   - Use Set for O(1) lookups
   - Calculate active participant from memory

3. **app/models/draft.rb**
   - Added memoization for expensive methods
   - Added counter cache association
   - Added `with_full_associations` scope for reusable optimized loading

4. **app/models/draft_participant.rb**
   - Added counter cache association
   - Updated count usage to use cache

5. **app/components/pick_list_component.rb**
   - Added optimized helper methods
   - Use preloaded data instead of new queries

6. **app/components/pick_list_component.html.erb**
   - Updated to use optimized component methods

7. **db/migrate/20260219073651_add_performance_indexes_to_draft_tables.rb**
   - Added performance indexes
   - Added counter cache column
   - Initialize existing counter cache values

## Next Steps

1. **Run the migration**: `bin/rails db:migrate`
2. **Monitor performance**: Use tools like `rack-mini-profiler` or `bullet` gem to verify N+1 elimination
3. **Test thoroughly**: Ensure all functionality works with the optimizations
4. **Consider caching**: For very large drafts, consider fragment caching for the pick list

## Additional Recommendations

1. **Add monitoring**: Consider adding query monitoring to catch future N+1 issues
2. **Use bullet gem**: Add the bullet gem in development to detect N+1 queries
3. **Pagination**: For very large cube cards lists, consider pagination
4. **Background processing**: Move expensive operations to background jobs where possible

## Testing the Optimizations

To verify the optimizations are working:

1. Check the Rails log for query reduction
2. Use development tools like:
   ```ruby
   # In rails console
   ActiveRecord::Base.logger = Logger.new(STDOUT)
   # Then load a draft show page and count queries
   ```
3. Use performance monitoring tools to measure page load times



