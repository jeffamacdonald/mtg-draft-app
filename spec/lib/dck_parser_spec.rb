require 'rails_helper'

RSpec.describe DckParser do
  describe '#call' do
    let(:line1) { '1 [LEB:123] Lightning Bolt' }
    let(:line2) { '1 [RAV1:321] Dark Confidant' }
    let(:file) do
      Tempfile.new(['test', '.dck']).tap do |f|
        f.puts line1
        f.puts line2
        f.close
      end
    end
    let(:expected_cards) do
      [
        Import::Card.new(count: 1, set: "LEB", name: "Lightning Bolt"),
        Import::Card.new(count: 1, set: "RAV1", name: "Dark Confidant")
      ]
    end
    let(:expected_errors) do
      []
    end

    after do
      file.unlink
    end

    subject { described_class.new(file.path).call }

    context 'when file is valid' do
      it 'parses cards' do
        expect(subject.first).to match_array(expected_cards)
        expect(subject.last).to match_array(expected_errors)
      end
    end

    context "with invalid line" do
      let(:expected_cards) do
        [Import::Card.new(count: 1, set: "RAV1", name: "Dark Confidant")]
      end

      context 'when one line has invalid count' do
        let(:card_name) {"Some Card"}
        let(:line1) { "0 [SET:123] #{card_name}" }
        let(:expected_errors) do
          [Import::InvalidRecord.new(name: card_name, error_message: "Count Invalid")]
        end

        it 'tracks invalid records and doesnt add record to parsed cards' do
          expect(subject.first).to match_array(expected_cards)
          expect(subject.last).to match_array(expected_errors)
        end
      end

      context 'when one line has invalid set' do
        let(:card_name) {"Some Card"}
        let(:line1) { "1 [SE:123] #{card_name}" }
        let(:expected_errors) do
          [Import::InvalidRecord.new(name: card_name, error_message: "Set Invalid")]
        end

        it 'tracks invalid records and doesnt add record to parsed cards' do
          expect(subject.first).to match_array(expected_cards)
          expect(subject.last).to match_array(expected_errors)
        end
      end

      context 'when name is empty string' do
        let(:line1) { "1 [SET:123]  " }
        let(:expected_errors) do
          [Import::InvalidRecord.new(name: "N/A", error_message: "Unknown card, name is blank")]
        end

        it 'tracks invalid records and doesnt add record to parsed cards' do
          expect(subject.first).to match_array(expected_cards)
          expect(subject.last).to match_array(expected_errors)
        end
      end
    end
  end
end
