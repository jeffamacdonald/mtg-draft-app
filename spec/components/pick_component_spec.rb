require "rails_helper"

RSpec.describe PickComponent, type: :component do
  def component_for(updated_at:, picked:)
    pick = instance_double(ParticipantPick, updated_at:, grid_cube_card: picked ? double : nil)
    described_class.new(pick)
  end

  describe "#slam_class" do
    it "is set for a pick made just now" do
      expect(component_for(updated_at: 1.second.ago, picked: true).send(:slam_class)).to eq("pick-slam")
    end

    it "is not set for an older pick" do
      expect(component_for(updated_at: 1.minute.ago, picked: true).send(:slam_class)).to be_nil
    end

    it "is not set for an empty cell" do
      expect(component_for(updated_at: 1.second.ago, picked: false).send(:slam_class)).to be_nil
    end
  end
end
