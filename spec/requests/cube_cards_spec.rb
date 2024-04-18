require 'rails_helper'

RSpec.describe CubeCardsController, type: :request do
  describe 'GET #edit' do
    let(:cube_card) { create(:cube_card) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get edit_cube_card_path(cube_card)
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:cube_card) { create(:cube_card) }
    let(:valid_params) do
      {
        cube_card: {
          count: 2,
          custom_set: 'P3K',
          custom_image: 'custom_image.jpg',
          custom_cmc: 3,
          custom_color_identity: ['W', 'U', 'B']
        }
      }
    end
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context 'with valid parameters' do
      it 'updates the cube card' do
        patch cube_card_path(cube_card), params: valid_params
        cube_card.reload
        expect(cube_card.count).to eq(2)
        expect(cube_card.custom_set).to eq('P3K')
        expect(cube_card.custom_image).to eq('custom_image.jpg')
        expect(cube_card.custom_cmc).to eq(3)
        expect(cube_card.custom_color_identity).to eq(['W', 'U', 'B'])
      end

      it 'redirects to the cube show page' do
        patch cube_card_path(cube_card), params: valid_params
        expect(response).to redirect_to(cube_path(cube_card.cube))
      end

      it 'sets a success flash message' do
        patch cube_card_path(cube_card), params: valid_params
        expect(flash[:success]).to eq('Cube card changes saved')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          cube_card: {
            count: nil,
            custom_set: 'P3K',
            custom_image: 'custom_image.jpg',
            custom_cmc: 3,
            custom_color_identity: ['W', 'U', 'B']
          }
        }
      end

      it 'does not update the cube card' do
        expect {
          patch cube_card_path(cube_card), params: invalid_params
        }.not_to change { cube_card }
      end

      it 'redirects to edit' do
        patch cube_card_path(cube_card), params: invalid_params
        expect(response).to redirect_to edit_cube_card_path(cube_card)
      end

      it 'sets a error flash message' do
        patch cube_card_path(cube_card), params: invalid_params
        expect(flash[:error]).to eq("Cube card changes failed: Count can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:cube_card) { create(:cube_card) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'soft deletes the cube card' do
      delete cube_card_path(cube_card)
      expect(cube_card.reload.soft_delete).to eq(true)
    end

    it 'redirects to the cube show page' do
      delete cube_card_path(cube_card)
      expect(response).to redirect_to(cube_path(cube_card.cube))
    end

    it 'sets a success flash message' do
      delete cube_card_path(cube_card)
      expect(flash[:success]).to eq('Cube card deleted')
    end
  end
end
