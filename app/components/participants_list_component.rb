class ParticipantsListComponent < ViewComponent::Base
  attr_reader :draft

  def initialize(draft:)
    @draft = draft
  end
end
