class AddPerformanceIndexesToDraftTables < ActiveRecord::Migration[7.1]
  def change
    # Add counter cache for participants
    add_column :drafts, :participants_count, :integer, default: 0, null: false

    # Optimize participant picks ordering and filtering
    add_index :participant_picks, [:draft_participant_id, :pick_number], name: 'index_participant_picks_on_participant_and_pick_number'
    add_index :participant_picks, [:cube_card_id, :round], name: 'index_participant_picks_on_card_and_round'

    # Optimize draft participants ordering
    add_index :draft_participants, [:draft_id, :draft_position, :skipped], name: 'index_draft_participants_on_draft_position_skipped'

    # Optimize cube cards filtering and color identity lookups
    add_index :cube_cards, [:cube_id, :soft_delete, :custom_cmc], name: 'index_cube_cards_on_cube_soft_delete_cmc'

    # Initialize counter cache values
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE drafts 
          SET participants_count = (
            SELECT COUNT(*) 
            FROM draft_participants 
            WHERE draft_participants.draft_id = drafts.id
          )
        SQL
      end
    end
  end
end


