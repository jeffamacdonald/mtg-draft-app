module Import
  class DckFile
    attr_reader :import_cards, :cube, :errors

    def initialize(import_cards, cube)
      @import_cards = import_cards
      @cube = cube
      @errors = []
    end

    def import
      existing_cards_with_set, cards_to_import = partition_import_cards
      scryfall_cards, @errors = scryfall_data(cards_to_import)
      if errors.empty?
        create_new_cards!(scryfall_cards)
        create_cube_cards_from_existing_list!(existing_cards_with_set)
        create_cube_cards_from_scryfall_list!(scryfall_cards)
        true
      else
        false
      end
    end

    private

    def partition_import_cards
      import_cards.partition do |import_card|
        card = existing_cards.find { |card| card.name == import_card.name }
        card&.cube_cards&.where(custom_set: import_card.set)&.exists?
      end
    end

    def existing_cube_cards
      @existing_cube_cards ||= import_cards.select do |import_card|
        card = existing_cards.find { |card| card.name == import_card.name }
        # select card if cube card record with same set exists
        card&.cube_cards.where(custom_set: import_card.set).exists?
      end
    end

    def existing_cards
      @existing_cards ||= ::Card.with_names(import_cards.map(&:name))
    end

    def scryfall_data(cards_to_import)
      client_cards, client_errors = [], []
      cards_to_import.each_slice(75) do |group|
        scryfall_cards, scryfall_errors = Clients::Scryfall.new.get_card_list(group)
        client_cards += scryfall_cards
        client_errors += scryfall_errors
      end
      [client_cards, client_errors]
    end

    def create_new_cards!(scryfall_cards)
      scryfall_cards.each do |scryfall_card|
        return if ::Card.where(name: scryfall_card.name).exists?

        scryfall_card.create_card!
      end
    end

    def create_cube_cards_from_existing_list!(import_cards)
      import_cards.each do |import_card|
        existing_cube_card = CubeCard.joins(:card).find_by(card: { name: import_card.name }, custom_set: import_card.set)
        CubeCard.create!(
          cube: cube,
          card: existing_cube_card.card,
          count: import_card.count,
          custom_image: existing_cube_card.custom_image,
          custom_cmc: existing_cube_card.cmc,
          custom_color_identity: existing_cube_card.card.color_identity.color_identities,
          custom_set: import_card.set
        )
      end
    end

    def create_cube_cards_from_scryfall_list!(scryfall_cards)
      scryfall_cards.each do |scryfall_card|
        existing_card = ::Card.find_by(name: scryfall_card.name)
        CubeCard.create!(
          cube: cube,
          card: existing_card,
          count: scryfall_card.count,
          custom_image: scryfall_card.image_uri,
          custom_cmc: existing_card.cmc,
          custom_color_identity: existing_card.color_identity.color_identities,
          custom_set: scryfall_card.set
        )
      end
    end
  end
end
