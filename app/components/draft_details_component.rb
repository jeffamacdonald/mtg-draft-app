class DraftDetailsComponent < ViewComponent::Base
  attr_reader :draft, :cube

  def initialize(draft:)
    @draft = draft
    @cube = draft.cube
  end
end
