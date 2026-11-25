require "rails_helper"

# The cube card list is fragment-cached; these cover what must (and must not) invalidate it.
RSpec.describe "GET /drafts/:id (cube list fragment cache)", type: :request do
  let(:cube) { create(:cube) }
  let(:draft) { create(:draft, cube: cube, status: DraftStatus.active) }
  let(:user) { create(:user) }
  let(:participant) { create(:draft_participant, draft: draft) }
  let!(:first_card) { add_card(name: "First Card", cmc: 1) }
  let!(:second_card) { add_card(name: "Second Card", cmc: 5) }

  around do |example|
    classes = [ ActionController::Base, ApplicationController, DraftsController ]
    original = classes.map { |klass| [ klass.perform_caching, klass.cache_store ] }
    store = ActiveSupport::Cache::MemoryStore.new
    classes.each { |klass| klass.perform_caching = true && klass.cache_store = store }
    example.run
  ensure
    classes.zip(original) { |klass, (caching, old_store)| klass.perform_caching = caching && klass.cache_store = old_store }
  end

  before { sign_in user }

  def add_card(name:, cmc:)
    card = create(:card, name: name, color_identity: [ "W" ], cmc: cmc, type_line: "Creature - Elf", card_text: "Text")
    create(:cube_card, cube: cube, card: card, color_identity: [ "W" ], custom_cmc: cmc)
  end

  def card_ids_in_page
    response.body.scan(/id="magic_card_([0-9a-f-]{36})"/).flatten
  end

  def tile_queries
    queries = 0
    counter = ->(*, payload) { queries += 1 if payload[:sql].include?('"cards"."name"') }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { yield }
    queries
  end

  it "serves the list from the cache without loading the cards" do
    get draft_path(draft)
    first_html = response.body

    expect(tile_queries { get draft_path(draft) }).to eq(0)
    expect(response.body).to eq(first_html)
  end

  it "shows a newly picked card as picked" do
    get draft_path(draft)
    expect(response.body).not_to include("cube_card__img__picked")

    create(:participant_pick, draft_participant: participant, cube_card: first_card)
    get draft_path(draft)

    expect(response.body).to match(/id="magic_card_#{first_card.id}"[^>]*>\s*<div class="d-flex">\s*<img[^>]*cube_card__img__picked/)
  end

  it "caches each filter combination separately" do
    get draft_path(draft)
    get draft_path(draft), params: { filters: { query: "mv=5" } }

    expect(card_ids_in_page).to eq([ second_card.id ])
  end

  it "caches each display mode separately" do
    get draft_path(draft)
    user.update!(default_display: "text")
    get draft_path(draft)

    expect(response.body).not_to include("<img")
    expect(response.body).to include("First Card")
  end

  it "reflects a soft-deleted cube card" do
    get draft_path(draft)
    second_card.update!(soft_delete: true)
    get draft_path(draft)

    expect(card_ids_in_page).to eq([ first_card.id ])
  end

  it "reflects a changed card image" do
    get draft_path(draft)
    first_card.update!(custom_image: "https://example.com/new.png")
    get draft_path(draft)

    expect(response.body).to include("https://example.com/new.png")
  end
end
