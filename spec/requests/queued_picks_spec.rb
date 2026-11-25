require 'rails_helper'

RSpec.describe QueuedPicksController, type: :request do
  let!(:user) { create(:user) }
  let!(:draft) { create(:draft) }
  let!(:draft_participant) { create(:draft_participant, draft: draft, user: user) }
  let!(:cube_card) { create(:cube_card) }
  let!(:queued_pick) { create(:queued_pick, draft_participant: draft_participant, cube_card: cube_card, priority_number: 1) }

  before do
    sign_in user
    stub_request(:get, "https://api.scryfall.com/cards/named?exact=#{cube_card.card.name}").to_return(status: 200, body: {:image_uris => {:normal => nil}}.to_json, headers: {})
  end

  describe "GET #new" do
    it "assigns the correct draft participant and cube card" do
      get new_queued_pick_path, params: { draft_participant_id: draft_participant.id, cube_card_id: cube_card.id }
      
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    let(:new_card) { create(:cube_card) }
    let(:queued_pick_params) { { cube_card_id: new_card.id, draft_participant_id: draft_participant.id, priority_number: 2 } }

    it "creates a new QueuedPick" do
      expect {
        post queued_picks_path, params: { queued_pick: queued_pick_params }
      }.to change(QueuedPick, :count).by(1)

      expect(response).to redirect_to(draft_path(draft))
      follow_redirect!
      expect(response.body).to include("Added to queue")
    end
  end

  describe "DELETE #destroy" do
    it "removes the queued pick" do
      expect {
        delete queued_pick_path(queued_pick)
      }.to change(QueuedPick, :count).by(-1)

      expect(response).to redirect_to(pick_queue_draft_participant_path(draft_participant))
    end

    it "closes the card modal and removes the card from the queue page with a turbo stream" do
      expect {
        delete queued_pick_path(queued_pick), as: :turbo_stream
      }.to change(QueuedPick, :count).by(-1)

      expect(response).to be_successful
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(%(<turbo-stream action="remove" target="#{queued_pick.id}_border">))
      expect(response.body).to match(/<turbo-stream action="update" target="modal">\s*<template><\/template>/)
    end
  end

  describe "PATCH #update_order" do
    let(:new_card) { create(:cube_card) }
    let!(:queued_pick_2) { create(:queued_pick, draft_participant: draft_participant, priority_number: 2, cube_card: new_card) }

    it "updates the priority order of queued picks" do
      patch update_order_queued_picks_path, params: { queued_pick_ids: [queued_pick_2.id, queued_pick.id] }

      expect(response).to have_http_status(:ok)
      expect(queued_pick_2.reload.priority_number).to eq(1)
      expect(queued_pick.reload.priority_number).to eq(2)
    end

    it "ignores queued picks that belong to another user" do
      other_pick = create(:queued_pick, draft_participant: create(:draft_participant, draft: draft), priority_number: 5)

      patch update_order_queued_picks_path, params: { queued_pick_ids: [ other_pick.id, queued_pick.id ] }

      expect(other_pick.reload.priority_number).to eq(5)
      expect(queued_pick.reload.priority_number).to eq(2)
    end

    it "treats ids as data, not SQL" do
      patch update_order_queued_picks_path, params: { queued_pick_ids: [ "' OR 1=1 --", queued_pick.id ] }

      expect(response).to have_http_status(:ok)
      expect(queued_pick.reload.priority_number).to eq(2)
      expect(queued_pick_2.reload.priority_number).to eq(2)
    end
  end
end
