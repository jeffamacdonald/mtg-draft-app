class ScryfallLinkComponent < ViewComponent::Base
  attr_reader :card

  def initialize(card:)
    @card = card
  end

  def scryfall_uri
    return card.scryfall_uri if card.scryfall_uri.present?

    card_data = Clients::Scryfall.new.get_card(card.name)
    card.update!(scryfall_uri: card_data[:scryfall_uri])
    card_data[:scryfall_uri]
  end
end