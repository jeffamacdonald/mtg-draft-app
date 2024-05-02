class AddActiveRoundToDraft < ActiveRecord::Migration[7.0]
  def change
    add_column :drafts, :active_round, :integer
  end
end
