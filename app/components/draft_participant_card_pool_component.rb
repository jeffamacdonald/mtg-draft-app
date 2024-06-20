# frozen_string_literal: true

class DraftParticipantCardPoolComponent < ViewComponent::Base
  attr_reader :draft_participant

  def initialize(draft_participant:)
    @draft_participant = draft_participant
  end

  def context
    @_context ||= MagicCardContext.for_view_only
  end

  def zero_cost_cards
    draft_participant.cube_cards.with_cmc(0)
  end

  def one_cost_cards
    draft_participant.cube_cards.with_cmc(1)
  end

  def two_cost_cards
    draft_participant.cube_cards.with_cmc(2)
  end

  def three_cost_cards
    draft_participant.cube_cards.with_cmc(3)
  end

  def four_cost_cards
    draft_participant.cube_cards.with_cmc(4)
  end

  def five_cost_cards
    draft_participant.cube_cards.with_cmc(5)
  end

  def six_cost_cards
    draft_participant.cube_cards.with_cmc(6)
  end

  def seven_plus_cost_cards
    draft_participant.cube_cards.with_cmc_greater_than(6)
  end
end
