require 'rails_helper'

RSpec.describe CubesController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:cube) { create(:cube, owner: user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get cubes_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:cube) { create(:cube, :with_cube_cards) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get cube_path(cube)
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'returns a successful response' do
      get new_cube_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:valid_params) do
      {
        cube: {
          name: 'Test Cube',
          import_file: fixture_file_upload('test_cube.dck', 'text/plain')
        }
      }
    end

    before do
      sign_in user
    end

    context 'with valid parameters' do
      let(:cube_list) {
        [{
          :count => 1,
          :set => "LEB",
          :name => "Lightning Bolt"
        }, {
          :count => 1,
          :set => "RAV1",
          :name => "Dark Confidant"
        }]
      }
      before do
        allow_any_instance_of(DckParser).to receive(:get_parsed_list).and_return([cube_list, []])
        expect_any_instance_of(Cube).to receive(:setup_cube_from_list).with(cube_list)
      end

      it 'creates a new cube' do
        expect {
          post cubes_path, params: valid_params
        }.to change { Cube.count }.by(1)
      end

      it 'redirects to the cubes index page' do
        post cubes_path, params: valid_params
        expect(response).to redirect_to(cubes_path)
      end
    end

    context 'when deck parser returns errors' do
      before do
        allow_any_instance_of(DckParser).to receive(:get_parsed_list).and_return([[], ["error1", "error2"]])
      end

      it 'does not create a new cube' do
        expect {
          post cubes_path, params: valid_params
        }.to_not change { Cube.count }
      end

      it 'redirects to new' do
        post cubes_path, params: valid_params
        expect(response).to redirect_to(new_cube_path)
      end
    end
  end
end
