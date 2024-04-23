require 'faraday'
require 'cgi'

module Clients
  class Scryfall
    BASE_URL = "https://api.scryfall.com"

    def initialize
      @client = Faraday.new BASE_URL do |faraday|
        faraday.use Faraday::Response::RaiseError
        faraday.response :json, :parser_options => { :symbolize_names => true }
      end
    end

    def get_card(name, set = nil)
      @client.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      response = @client.get("/cards/named?exact=#{card_params(name, set)}")
      CardSanitizer.call(response.body, Import::Card.new(name:, set:))
    end

    def get_card_list(import_cards)
      @client.headers['Content-Type'] = 'application/json'
      response = @client.post("/cards/collection", card_list_params(import_cards).to_json)
      sanitize_list(response.body, import_cards)
    end

    private

    def sanitize_list(response_body, card_list)
      scryfall_cards = response_body[:data].map do |card_data|
        import_card = card_list.find { |card| card_data[:name].include? card.name }
        CardSanitizer.call(card_data, import_card)
      end
      errors = response_body[:not_found].map do |error|
        "#{error[:name]} was not found."
      end
      [scryfall_cards, errors]
    end

    def card_params(name, set)
      encoded_name = CGI.escape name
      params = set.nil? ? encoded_name : encoded_name + "&set=#{set}"
    end

    def card_list_params(import_cards)
      {
        :identifiers => import_cards.map do |card|
          {
            :name => parsed_card_name(card.name),
            :set => card.set
          }
        end
      }
    end

    def parsed_card_name(card_name)
      if card_name.include? "//"
        card_name.split("//").first
      else
        card_name
      end
    end
  end
end
