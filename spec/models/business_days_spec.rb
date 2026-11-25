require "rails_helper"

RSpec.describe BusinessDays do
  describe ".off?" do
    it "is true on weekends" do
      expect(described_class.off?(Time.zone.local(2026, 11, 28, 12))).to eq true # Saturday
      expect(described_class.off?(Time.zone.local(2026, 11, 29, 12))).to eq true # Sunday
    end

    it "is true on a US holiday that falls on a weekday" do
      expect(described_class.off?(Time.zone.local(2026, 12, 25, 12))).to eq true # Friday
    end

    it "is false on an ordinary weekday" do
      expect(described_class.off?(Time.zone.local(2026, 11, 25, 12))).to eq false # Wednesday
    end
  end
end
