class CreateTransferPortal < ActiveRecord::Migration[7.1]
  def change
    create_table :transfer_portal_transactions, id: :uuid do |t|
      t.references :draft, foreign_key: { to_table: :drafts }, type: :uuid, null: false
      t.references :offerer, foreign_key: { to_table: :draft_participants }, type: :uuid, null: false
      t.string :status, default: "pending", null: false
      t.datetime :expires_at

      t.timestamps
    end

    create_table :transfer_portal_transaction_offerings, id: :uuid do |t|
      t.references :transfer_portal_transaction, foreign_key: { to_table: :transfer_portal_transactions }, type: :uuid, null: false
      t.references :sender, foreign_key: { to_table: :draft_participants }, type: :uuid, null: false
      t.references :receiver, foreign_key: { to_table: :draft_participants }, type: :uuid, null: false
      t.references :participant_pick, foreign_key: { to_table: :participant_picks }, type: :uuid, null: false

      t.timestamps
    end
  end
end
