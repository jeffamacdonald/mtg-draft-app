# frozen_string_literal: true

# Page title card: a small DisplayCard with the page title inside.
class TitleCardComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
