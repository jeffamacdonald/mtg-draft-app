require 'rails_helper'

RSpec.describe 'ParticipantPicks', type: :request do
  let(:user) { create(:user) }
  let(:cube) { create(:cube, owner: user) }
  let(:draft) { create(:draft, cube:, owner: user, status: 'active') }
  let(:draft_participant) { create(:draft_participant, draft:) }
  let(:cube_card) { create(:cube_card, cube:) }

  before do
    sign_in user
  end

  describe 'GET /participant_picks/new' do
    it 'renders the new pick form' do
    #   TODO
    end

    it "submits a PATCH for the drafter's next open pick" do
      draft_participant = create(:draft_participant, draft:, user:)
      open_pick = create(:participant_pick, draft_participant:, cube_card: nil)
      stub_request(:get, "https://api.scryfall.com/cards/named?exact=#{cube_card.card.name}")
        .to_return(status: 200, body: { image_uris: { normal: nil } }.to_json)

      get new_participant_pick_path, params: { draft_participant_id: draft_participant.id, cube_card_id: cube_card.id }

      form = Nokogiri::HTML(response.body).at_css('form#pick_form')
      expect(form['action']).to eq(pick_participant_pick_path(open_pick))
      expect(form.at_css('input[name="_method"]')['value']).to eq('patch')
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get new_participant_pick_path, params: {
          draft_participant_id: draft_participant.id,
          cube_card_id: cube_card.id
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /participant_picks/:id/pick' do
    let(:draft_participant) { create(:draft_participant, draft:, user:) }
    let!(:open_pick) { create(:participant_pick, draft_participant:, cube_card: nil) }
    let(:pick_params) { { participant_pick: { cube_card_id: cube_card.id } } }

    subject(:make_pick) { patch pick_participant_pick_path(open_pick), params: pick_params }

    context 'when picking for yourself' do
      it 'makes that pick, notifies the next drafter and redirects to the draft' do
        expect(Drafts::MakePick).to receive(:call)
          .with(draft_participant:, cube_card:, participant_pick_id: open_pick.id)
          .and_return(open_pick)
        expect(Drafts::NotifyNextUp).to receive(:call).with(pick: open_pick, except_user: user).and_return(true)

        make_pick

        expect(response).to redirect_to(draft_path(draft))
        expect(flash[:error]).to be_nil
      end
    end

    context 'when picking as a surrogate' do
      let(:draft_participant) { create(:draft_participant, draft:) }
      let(:surrogate) { create(:draft_participant, draft:, user:) }
      let!(:surrogacy) { create(:surrogate_draft_participant, draft_participant:, surrogate_participant: surrogate) }

      it 'makes the pick' do
        expect(Drafts::MakePick).to receive(:call).and_return(open_pick)
        allow(Drafts::NotifyNextUp).to receive(:call).and_return(true)

        make_pick

        expect(response).to redirect_to(draft_path(draft))
      end
    end

    shared_examples 'a rejected pick' do
      it 'does not make the pick and flashes an error' do
        expect(Drafts::MakePick).not_to receive(:call)

        make_pick

        expect(response).to redirect_to(draft_path(draft))
        expect(flash[:error]).to include("can't make picks")
        expect(open_pick.reload.cube_card).to be_nil
      end
    end

    context 'when another drafter in the draft submits it' do
      let(:draft_participant) { create(:draft_participant, draft:) }
      let!(:other_participant) { create(:draft_participant, draft:, user:) }

      it_behaves_like 'a rejected pick'
    end

    context 'when someone outside the draft submits it' do
      let(:draft_participant) { create(:draft_participant, draft:) }

      it_behaves_like 'a rejected pick'
    end

    context 'when it is no longer the participant\'s turn' do
      before { allow(Drafts::MakePick).to receive(:call).and_raise(Drafts::MakePick::StalePick) }

      it 'redirects to the draft, flashes an error and sends no email' do
        expect(PickMailer).not_to receive(:next_up_email)

        make_pick

        expect(response).to redirect_to(draft_path(draft))
        expect(flash[:error]).to include('your turn changed')
      end
    end

    context 'when the next-up email fails to send' do
      let(:next_participant) { create(:draft_participant, draft:) }

      before do
        allow(Drafts::MakePick).to receive(:call).and_return(open_pick)
        allow_any_instance_of(Draft).to receive(:active_participant).and_return(next_participant)
        allow(PickMailer).to receive(:next_up_email).and_raise(StandardError, 'Zoho token refresh failed')
      end

      it 'still redirects to the draft and flashes an error' do
        make_pick

        expect(response).to redirect_to(draft_path(draft))
        expect(flash[:error]).to include('failed to send')
      end
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        make_pick

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /participant_picks/:id' do
    let(:participant_pick) { create(:participant_pick, draft_participant:, cube_card: nil, comment: 'Nice pool') }

    it 'renders the comment inside its turbo frame with an edit link' do
      get participant_pick_path(participant_pick)

      expect(response).to be_successful
      expect(response.body).to include("participant_pick_#{participant_pick.id}_comment")
      expect(response.body).to include('Nice pool')
      expect(response.body).to include(edit_participant_pick_path(participant_pick))
      expect(response.body).not_to include('<html')
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get participant_pick_path(participant_pick)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /participant_picks/:id/edit' do
    let(:participant_pick) { create(:participant_pick, draft_participant:, cube_card: nil, comment: 'Nice pool') }

    it 'renders the comment form inside the pick comment frame' do
      get edit_participant_pick_path(participant_pick)

      expect(response).to be_successful
      expect(response.body).to include("participant_pick_#{participant_pick.id}_comment")
      expect(response.body).to include('name="participant_pick[comment]"')
      expect(response.body).to include('value="Nice pool"')
      expect(response.body).not_to include('<html')
    end

    it 'dismisses on an outside click instead of offering a cancel button' do
      get edit_participant_pick_path(participant_pick)

      expect(response.body).to include('data-controller="dismiss-edit"')
      expect(response.body).to include(%(data-dismiss-edit-url-value="#{participant_pick_path(participant_pick)}"))
      expect(response.body).not_to include('Cancel')
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get edit_participant_pick_path(participant_pick)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /participant_picks/:id' do
    let(:participant_pick) { create(:participant_pick, draft_participant: draft_participant) }
    let(:update_params) do
      {
        id: participant_pick.id,
        participant_pick: { comment: 'Great card!' }
      }
    end

    it 'updates the participant pick comment' do
      patch participant_pick_path(participant_pick), params: update_params, as: :turbo_stream

      participant_pick.reload
      expect(participant_pick.comment).to eq('Great card!')
      expect(response).to have_http_status(:success)
    end

    it 'broadcasts the update' do
      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to)

      patch participant_pick_path(participant_pick), params: update_params, as: :turbo_stream
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        patch participant_pick_path(participant_pick), params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /participant_picks/:id/hovercard' do
    let(:participant_pick) { create(:participant_pick, draft_participant: draft_participant) }

    it 'renders hovercard without layout' do
      get hovercard_participant_pick_path(participant_pick)

      expect(response).to have_http_status(:success)
    end

    context 'when not signed in' do
      before { sign_out user }

      it 'redirects to sign in' do
        get hovercard_participant_pick_path(participant_pick)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
