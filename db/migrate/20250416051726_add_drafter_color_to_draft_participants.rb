class AddDrafterColorToDraftParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :draft_participants, :display_color, :string
  end
end
