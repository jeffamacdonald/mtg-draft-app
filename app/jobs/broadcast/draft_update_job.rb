module Broadcast
	class DraftUpdateJob < ApplicationJob
  	queue_as :default
  	
		def perform(draft)
			draft.users.each do |user|
	      context = MagicCardContext.for_active_draft(
	        draft: draft, 
	        draft_participant: draft.draft_participants.find_by(user: user), 
	        text_only: user.default_display == "text", 
	        image_size: user.default_image_size)
	      cube_cards = draft.cube.cube_cards
	        .select(
	          "cube_cards.*",
	          "cards.name",
	          "cards.type_line",
	          "cards.card_text"
	        )
	        .active.sorted
	      Turbo::StreamsChannel.broadcast_replace_to(
	        user,
	        target: "draft_#{draft.id}_show_body",
	        partial: "drafts/show_body",
	        locals: { draft: draft, context: context, filter_params: {}, cube_cards: cube_cards }
	      )
	    end
		end
	end
end