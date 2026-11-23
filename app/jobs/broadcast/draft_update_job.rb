module Broadcast
  class DraftUpdateJob < ApplicationJob
    queue_as :default

    # Re-renders the draft body once per distinct display setting (not once per user)
    # and broadcasts that HTML to every user who shares those settings.
    def perform(draft)
      draft = Draft.with_full_associations.find(draft.id)
      cube_cards = draft.cube.cube_cards.for_display.active.sorted.to_a

      draft.draft_participants.group_by { |participant| display_settings(participant.user) }.each do |settings, participants|
        html = render_body(draft, cube_cards, participants.first, settings)
        participants.each do |participant|
          Turbo::StreamsChannel.broadcast_replace_to(participant.user, target: "draft_#{draft.id}_show_body", content: html)
        end
      end
    end

    private

    # Everything in the rendered body that varies by user (see MagicCardContext,
    # PickListComponent and CubeFiltersComponent).
    def display_settings(user)
      [ user.default_display, user.default_image_size, user.pick_list_size ]
    end

    def render_body(draft, cube_cards, participant, (display, image_size, _pick_list_size))
      context = MagicCardContext.for_active_draft(
        draft:, draft_participant: participant, text_only: display == "text", image_size:
      )
      ApplicationController.render(
        formats: [ :html ],
        partial: "drafts/show_body",
        locals: { draft:, context:, filter_params: {}, cube_cards: }
      )
    end
  end
end
