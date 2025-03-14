class ZohoDeliveryMethod
	attr_reader :mailer

	def initialize(settings = {})
		puts settings
		@mailer = Clients::Zoho::Mail.new
	end

	def deliver!(mail)
		mailer.send_message(mail)
	end
end