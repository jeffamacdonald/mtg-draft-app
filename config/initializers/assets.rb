# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

# Configure Sprockets to avoid SCSS processing since we use yarn build:css
Rails.application.config.assets.configure do |env|
  # Remove SCSS processors to prevent sassc dependency
  env.unregister_mime_type('text/scss')
  env.unregister_mime_type('text/sass')
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
