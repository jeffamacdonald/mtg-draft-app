# == Schema Information
#
# Table name: cube_cards
#
#  id                    :uuid             not null, primary key
#  count                 :integer          not null
#  custom_cmc            :integer          not null
#  custom_color_identity :string           not null, is an Array
#  custom_image          :string           not null
#  custom_set            :string           not null
#  soft_delete           :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  card_id               :uuid
#  cube_id               :uuid
#
# Indexes
#
#  index_cube_cards_on_card_id                (card_id)
#  index_cube_cards_on_cube_id                (cube_id)
#  index_cube_cards_on_cube_soft_delete_cmc   (cube_id,soft_delete,custom_cmc)
#  index_cube_cards_on_custom_color_identity  (custom_color_identity)
#  index_cube_cards_on_soft_delete            (soft_delete)
#
# Foreign Keys
#
#  fk_rails_...  (card_id => cards.id)
#  fk_rails_...  (cube_id => cubes.id)
#
require 'rails_helper'

RSpec.describe CubeCard do
  describe "#color_identity" do
    let(:card) { create(:card) }
    let(:cube_card) { create(:cube_card, card: card) }
    subject { cube_card.color_identity }

    it "returns a ColorIdentity object" do
      expect(subject.class).to eq Card::ColorIdentity
    end

    it "returns the same object on repeated calls" do
      expect(cube_card.color_identity).to equal(cube_card.color_identity)
    end

    it "rebuilds when custom_color_identity is reassigned" do
      original = cube_card.color_identity

      cube_card.custom_color_identity = [ "U", "R" ]

      expect(cube_card.color_identity).not_to equal(original)
      expect(cube_card.color_identity.color_identities).to eq([ "R", "U" ])
    end

    it "reflects the stored value after reload" do
      cube_card.color_identity
      CubeCard.where(id: cube_card.id).update_all(custom_color_identity: [ "G" ])

      expect(cube_card.reload.color_identity.color_identities).to eq([ "G" ])
    end
  end
end
