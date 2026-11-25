# Stores the highest pick number that has been filled or skipped, so Draft#active_pick
# no longer scans every pick in the draft. Backfills existing drafts with the same rule.
class AddLastPickNumberToDrafts < ActiveRecord::Migration[7.1]
  def up
    add_column :drafts, :last_pick_number, :integer, default: 0, null: false

    execute <<~SQL
      UPDATE drafts
      SET last_pick_number = COALESCE((
        SELECT MAX(participant_picks.pick_number)
        FROM participant_picks
        JOIN draft_participants ON draft_participants.id = participant_picks.draft_participant_id
        WHERE draft_participants.draft_id = drafts.id
          AND (participant_picks.cube_card_id IS NOT NULL OR participant_picks.skipped = TRUE)
      ), 0)
    SQL
  end

  def down
    remove_column :drafts, :last_pick_number
  end
end
