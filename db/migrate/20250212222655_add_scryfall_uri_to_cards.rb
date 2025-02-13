class AddScryfallUriToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :scryfall_uri, :string
  end
end
