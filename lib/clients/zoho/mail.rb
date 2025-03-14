require "faraday"

module Clients
  module Zoho
    class Mail
      attr_reader :client
      BASE_URL = "https://mail.zoho.com"
      ACCOUNT_ID = ENV["ZOHO_ACCOUNT_ID"]

      def initialize
        @client = Faraday.new BASE_URL do |faraday|
          faraday.use Faraday::Response::RaiseError
          faraday.response :json, :parser_options => { :symbolize_names => true }
          faraday.ssl[:verify] = true
        end
      end

      def send_message(mail)
        client.post(
          "/api/accounts/#{ACCOUNT_ID}/messages",
          {
            "fromAddress" => mail.from.first,
            "toAddress" => mail.to.first,
            "subject" => mail.subject,
            "content" => mail.body.encoded
          }.to_json,
          { 
            "Content-Type" => "application/json",
            "Accept" => "application/json",
            "Authorization" => "Zoho-oauthtoken #{Clients::Zoho::Tokens.new.get}"
          }
        )
      end
    end
  end
end