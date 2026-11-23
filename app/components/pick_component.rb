class PickComponent < ViewComponent::Base
  attr_reader :participant_pick

  def initialize(participant_pick)
    @participant_pick = participant_pick
  end

  ID_PLACEHOLDER = "PICK_ID".freeze

  # The edit route is generated once per process with a placeholder id and the pick's
  # id substituted in: the route helper is the most expensive part of an empty cell.
  def self.edit_path_template
    @edit_path_template ||= Rails.application.routes.url_helpers.edit_participant_pick_path(ID_PLACEHOLDER).freeze
  end

  def edit_path
    self.class.edit_path_template.sub(ID_PLACEHOLDER, participant_pick.id.to_s)
  end

  # auto_link on a blank comment returns "", so skip the work for the (many) empty cells
  def comment_html
    return if participant_pick.comment.blank?

    helpers.auto_link(participant_pick.comment, html: { target: "_blank", class: "position-relative", style: "z-index: 2;" })
  end

  def picked?
    grid_cube_card.present?
  end

  def card_name
    grid_cube_card&.name
  end

  def pick_classes
    "#{pick_bg_class} #{pick_text_class} #{highlighted_class}"
  end

  def hovercard_controller
    return unless participant_pick.transfered?

    "hovercard"
  end

  def hovercard_url
    return unless participant_pick.transfered?

    hovercard_participant_pick_path(participant_pick)
  end

  def hovercard_actions
    return unless participant_pick.transfered?

    "mouseenter->hovercard#show mouseleave->hovercard#hide"
  end

  private

  def grid_cube_card
    participant_pick.grid_cube_card
  end

  def pick_bg_class
    return Card::SkippedColorIdentity.new.background_class if participant_pick.skipped?
    return if grid_cube_card.blank?

    grid_cube_card.color_identity.background_class
  end

  def pick_text_class
    return if grid_cube_card.blank?

    grid_cube_card.color_identity.text_class
  end

  def highlighted_class
    return unless participant_pick.transfered?

    "highlighted-pick"
  end
end
