# t.references :draft_participant, foreign_key: { to_table: :draft_participants }, type: :uuid
# t.references :surrogate_participant, foreign_key: { to_table: :draft_participants }, type: :uuid
# t.timestamps null: false

class SurrogateDraftParticipant < ApplicationRecord
  belongs_to :draft_participant
  belongs_to :surrogate_participant, class_name: "DraftParticipant"
end
