require "redis"
require "faraday"

module Clients
  module Zoho
    class Tokens
      attr_reader :client

      BASE_URL = "https://accounts.zoho.com"

      def initialize
        @client = Faraday.new BASE_URL do |faraday|
          faraday.use Faraday::Response::RaiseError
          faraday.response :json, :parser_options => { :symbolize_names => true }
        end
      end

      def get
        redis = Redis.new
        token = redis.get("zoho:access_token")
        if token && JSON.parse(token)["expires"].to_i >= Time.zone.now.to_i
          JSON.parse(token)["token"]
        else
          refresh_token
        end
      end

      private

      def refresh_token
        redis = Redis.new
        body = {
          grant_type: "client_credentials",
          client_id: ENV["ZOHO_CLIENT_ID"],
          client_secret: ENV["ZOHO_SECRET"],
          scope: "ZohoMail.messages.all,ZohoMail.accounts.all"
        }
        result = client.post(
          "/oauth/v2/token",
          URI.encode_www_form(body),
          { "Content-Type" => "application/x-www-form-urlencoded" }
        )
        if result.status == 200 
          token = result.body[:access_token]
          expires_in_sec = result.body[:expires_in]
          token_json = {
            token: token, 
            expires: (Time.zone.now + expires_in_sec).to_i 
          }.to_json
          redis.set("zoho:access_token", token_json)
          return token
        else
          return false
        end
      end
    end
  end
end