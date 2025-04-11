class TransferPortalDraftParticipantsComponent < ViewComponent::Base
	include Turbo::FramesHelper
	
	def initialize(draft:)
		@draft = draft
	end
end