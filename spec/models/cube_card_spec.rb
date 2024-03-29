require 'rails_helper'

RSpec.describe CubeCard do
  describe '#update_from_hash' do
    let(:card) { create :card }
    let(:cube_card) { create :cube_card, card_id: card.id }
    let(:update_hash) do
      {
        :count => 2,
        :set => '3ED',
        :custom_color_identity => 'R',
        :custom_cmc => 2,
        :soft_delete => true
      }
    end
    let(:image) { 'some_image' }
    let(:scryfall_response) do
      {
        :image_uri => image
      }
    end

    subject { cube_card.update_from_hash(update_hash) }

    context 'when set is different from card' do
      before do
        allow(CardEnricher).to receive(:get_enriched_card).and_return(scryfall_response)
      end

      it 'updates all fields including custom image' do
        subject
        expect(cube_card.count).to eq update_hash[:count]
        expect(cube_card.custom_set).to eq update_hash[:set]
        expect(cube_card.custom_image).to eq image
        expect(cube_card.custom_color_identity).to eq update_hash[:custom_color_identity]
        expect(cube_card.custom_cmc).to eq update_hash[:custom_cmc]
        expect(cube_card.soft_delete).to eq true
      end
    end
  end

  describe '.create_cube_card_from_hash' do
    let(:cube) { create :cube }
    let(:card) { create :card }
    let(:set) { 'LEB' }
    let(:default_image) { 'image' }
    let(:custom_color_identity) { nil }
    let(:color_identity) { 'R' }
    let(:custom_cmc) { nil }
    let(:cmc) { 1 }
    let(:count) { 1 }
    let(:card_hash) do
      {
        :name => 'Lightning Bolt',
        :default_set => 'LEB',
        :set => set,
        :id => card.id,
        :count => count,
        :default_image => default_image,
        :custom_color_identity => custom_color_identity,
        :color_identity => color_identity,
        :custom_cmc => custom_cmc,
        :cmc => cmc
      }
    end

    subject { described_class.create_cube_card_from_hash(cube, card_hash) }

    context 'when set is not custom' do
      it 'creates cube card with expected attributes' do
        subject
        cube_card = CubeCard.find_by(card_id: card.id)
        expect(cube_card.cube_id).to eq cube.id
        expect(cube_card.custom_set).to eq set
        expect(cube_card.custom_image).to eq default_image
        expect(cube_card.custom_color_identity).to eq color_identity
        expect(cube_card.custom_cmc).to eq cmc
        expect(cube_card.count).to eq count
        expect(cube_card.soft_delete).to eq false
      end
    end

    context 'when set is custom' do
      let(:custom_image) { 'custom' }
      let(:set) { '3ED' }

      before do
        allow(CubeCard).to receive(:get_custom_image).and_return(custom_image)
      end

      it 'creates cube card with custom image' do
        subject
        expect(CubeCard.find_by(card_id: card.id).custom_image).to eq custom_image
      end
    end

    context 'when color identity is custom' do
      let(:custom_color_identity) { 'C' }

      it 'creates cube card with custom color identity' do
        subject
        expect(CubeCard.find_by(card_id: card.id).custom_color_identity).to eq custom_color_identity
      end
    end

    context 'when cmc is custom' do
      let(:custom_cmc) { 2 }

      it 'creates cube card with custom cmc' do
        subject
        expect(CubeCard.find_by(card_id: card.id).custom_cmc).to eq custom_cmc
      end
    end
  end

  describe '.get_custom_image' do
    let(:card) { create :card }
    let(:card_image) { 'card_custom' }
    let!(:cube_card) { create :cube_card, card_id: card.id, custom_set: set, custom_image: card_image }
    let(:set) { 'LEB' }
    let(:name) { 'Lightning Bolt' }
    let(:custom_set) { '3ED' }
    let(:card_id) { card.id }
    let(:card_hash) do
      {
        :id => card_id,
        :set => custom_set,
        :name => name
      }
    end

    subject { described_class.get_custom_image(card_hash) }

    context 'when custom image is not found in cube cards' do
      let(:scryfall_image) { 'scryfall_image' }
      let(:scryfall_response) do
        {
          :image_uri => scryfall_image
        }
      end

      before do
        allow(CardEnricher).to receive(:get_enriched_card).and_return(scryfall_response)
      end

      it 'calls scryfall and returns image' do
        expect(subject).to eq scryfall_image
      end

      context 'when scryfall cannot find card in custom set' do
        let(:scryfall_response) do
          {
            :error => {
              :name => name,
              :set => custom_set,
              :message => "Card Not Found in Set"
            }
          }
        end

        it 'raises error' do
          expect{subject}.to raise_error(CubeCard::CreationError)
        end
      end
    end

    context 'when cube card contains custom image' do
      let(:set) { custom_set }

      it 'returns image from existing cube card' do
        expect(subject).to eq card_image
      end
    end
  end
end
