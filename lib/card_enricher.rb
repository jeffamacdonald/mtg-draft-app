class CardEnricher
  class << self
    def get_enriched_card(card_hash)
      scryfall_card = get_scryfall_card(card_hash)
      return scryfall_card if scryfall_card.is_a?(Hash)
      scryfall_card.count = card_hash[:count]
      if card_hash[:custom_color_identity].present?
        scryfall_card.color_identity = card_hash[:custom_color_identity]
      end
      if card_hash[:custom_cmc].present?
        scryfall_card.cmc = card_hash[:custom_cmc]
      end
      scryfall_card
    end

    private

    def get_scryfall_card(card_hash)
      begin
        Clients::Scryfall.new.get_card(card_hash[:name], card_hash[:set])
      rescue Faraday::ResourceNotFound
        if card_hash[:set].nil?
          {:error => {:name => card_hash[:name], :message => "Card Not Found"}}
        else
          {:error => {:name => card_hash[:name], :set => card_hash[:set], :message => "Card Not Found in Set"}}
        end
      end
    end
  end
end
