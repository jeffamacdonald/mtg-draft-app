require Rails.root.join('app', 'mailers', 'zoho_delivery_method')

ActionMailer::Base.add_delivery_method :zoho_mail, ZohoDeliveryMethod
ActionMailer::Base.delivery_method = :zoho_mail