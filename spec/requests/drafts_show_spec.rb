require 'rails_helper'

# Regression coverage for the cube card list on an active draft's show page.
RSpec.describe "GET /drafts/:id (active draft cube list)", type: :request do
  let(:cube) { create(:cube) }
  let(:draft) { create(:draft, cube: cube, status: DraftStatus.active) }
  let(:user) { create(:user) }

  before { sign_in user }

  def add_card(name:, color: [ "W" ], cmc: 2, type_line: "Creature - Elf", card_text: "Some text", **attrs)
    card = create(:card, name: name, color_identity: color, cmc: cmc, type_line: type_line, card_text: card_text)
    create(:cube_card, cube: cube, card: card, color_identity: color, custom_cmc: cmc, **attrs)
  end

  def card_ids_in_page
    response.body.scan(/id="magic_card_([0-9a-f-]{36})"/).flatten
  end

  def section_titles
    response.body.scan(/<div class="card-header fw-bold">([^<]+)<\/div>/).flatten
  end

  it "renders active cube cards and omits soft-deleted ones" do
    shown = add_card(name: "Shown Card")
    hidden = add_card(name: "Hidden Card", soft_delete: true)

    get draft_path(draft)

    expect(response).to be_successful
    expect(card_ids_in_page).to include(shown.id)
    expect(card_ids_in_page).not_to include(hidden.id)
  end

  it "groups cards into color sections in display order" do
    add_card(name: "W Card", color: [ "W" ])
    add_card(name: "U Card", color: [ "U" ])
    add_card(name: "B Card", color: [ "B" ])
    add_card(name: "R Card", color: [ "R" ])
    add_card(name: "G Card", color: [ "G" ])
    add_card(name: "Gold Card", color: [ "U", "R" ])
    add_card(name: "Colorless Card", color: [ "C" ])
    add_card(name: "Land Card", color: [ "L" ], type_line: "Land", card_text: "{T}: Add {C}.")

    get draft_path(draft)

    expect(section_titles).to eq(%w[White Blue Black Red Green Gold Colorless Land])
  end

  it "sorts cards by cmc, then creatures first, then name" do
    late = add_card(name: "A Late Spell", cmc: 5, type_line: "Sorcery")
    spell = add_card(name: "A Spell", cmc: 1, type_line: "Instant")
    creature_b = add_card(name: "B Creature", cmc: 1, type_line: "Creature - Elf")
    creature_a = add_card(name: "A Creature", cmc: 1, type_line: "Creature - Elf")

    get draft_path(draft)

    expect(card_ids_in_page).to eq([ creature_a, creature_b, spell, late ].map(&:id))
  end

  it "shows card names in text-only mode" do
    user.update!(default_display: "text")
    add_card(name: "Textual Card")

    get draft_path(draft)

    expect(response.body).to include("Textual Card")
    expect(response.body).not_to include("cube_card__img")
  end

  it "shows card images in image mode" do
    card = add_card(name: "Pictured Card")

    get draft_path(draft)

    expect(response.body).to include(card.custom_image)
    expect(response.body).to include("cube_card__img")
  end

  describe "filters" do
    let!(:cheap_white) { add_card(name: "Cheap White", color: [ "W" ], cmc: 1, type_line: "Creature - Elf", card_text: "Flying") }
    let!(:pricey_blue) { add_card(name: "Pricey Blue", color: [ "U" ], cmc: 5, type_line: "Sorcery", card_text: "Draw cards") }

    it "filters by cmc" do
      get draft_path(draft), params: { filters: { cmc: 5 } }
      expect(card_ids_in_page).to eq([ pricey_blue.id ])
    end

    it "filters by color" do
      get draft_path(draft), params: { filters: { color: "W" } }
      expect(card_ids_in_page).to eq([ cheap_white.id ])
    end

    it "filters by card text" do
      get draft_path(draft), params: { filters: { card_text: "Flying" } }
      expect(card_ids_in_page).to eq([ cheap_white.id ])
    end

    it "filters by card type" do
      get draft_path(draft), params: { filters: { card_type: "Sorcery" } }
      expect(card_ids_in_page).to eq([ pricey_blue.id ])
    end
  end

  describe "picked cards" do
    let(:participant) { create(:draft_participant, draft: draft) }
    let!(:picked) { add_card(name: "Picked Card") }
    let!(:available) { add_card(name: "Available Card") }

    before { create(:participant_pick, draft_participant: participant, cube_card: picked) }

    it "strikes through picked cards in text-only mode" do
      user.update!(default_display: "text")

      get draft_path(draft)

      expect(response.body).to match(/text-decoration-line-through">\s*Picked Card/)
      expect(response.body).not_to match(/text-decoration-line-through">\s*Available Card/)
    end

    it "marks picked cards in image mode" do
      get draft_path(draft)

      expect(response.body).to match(/id="magic_card_#{picked.id}"[^>]*>\s*<div class="d-flex">\s*<img[^>]*cube_card__img__picked/)
      expect(response.body).to match(/id="magic_card_#{available.id}"[^>]*>\s*<div class="d-flex">\s*<img[^>]*class="flex-fill cube_card__img"/)
    end
  end

  it "does not issue more queries as the cube grows" do
    count_queries = lambda do
      queries = 0
      counter = ->(*, payload) { queries += 1 unless payload[:name] == "SCHEMA" || payload[:cached] }
      ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { get draft_path(draft) }
      queries
    end

    2.times { |i| add_card(name: "Small #{i}") }
    get draft_path(draft) # warm-up: first request pays one-time query costs
    small = count_queries.call

    12.times { |i| add_card(name: "Large #{i}", color: %w[U B R G].sample(1)) }
    large = count_queries.call

    expect(large).to eq(small)
  end
end
