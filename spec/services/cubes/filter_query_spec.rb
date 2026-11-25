require "rails_helper"

RSpec.describe Cubes::FilterQuery do
  let(:cube) { create :cube }
  let!(:bolt) { create :cube_card, cube: cube, color_identity: [ "R" ], card: create(:card, name: "Lightning Bolt", cost: "{R}", cmc: 1, type_line: "Instant", card_text: "Deals 3 damage to any target.", color_identity: [ "R" ]) }
  let!(:bear) { create :cube_card, cube: cube, color_identity: [ "G" ], card: create(:card, name: "Grizzly Bears", cost: "{1}{G}", cmc: 2, type_line: "Creature — Bear", card_text: nil, power: 2, toughness: 2, color_identity: [ "G" ]) }
  let!(:gold) { create :cube_card, cube: cube, color_identity: [ "R", "G" ], card: create(:card, name: "Burning-Tree Emissary", cost: "{R/G}{R/G}", cmc: 2, type_line: "Creature — Goblin Shaman", card_text: "When this enters, add {R}{G}. (Reminder)", power: 2, toughness: 2, color_identity: [ "R", "G" ]) }
  let!(:land) { create :cube_card, cube: cube, color_identity: [ "L" ], card: create(:card, name: "Forest's Edge", cost: nil, cmc: 0, type_line: "Land", card_text: "{T}: Add {G}.", color_identity: [ "L" ]) }

  def names(query)
    filter = described_class.new(query)
    [ filter.apply(CubeCard.active.sorted).map { |cc| cc.card.name }.sort, filter.ignored ]
  end

  it "matches names, quoted and exact" do
    expect(names("bolt").first).to eq([ "Lightning Bolt" ])
    expect(names("!bolt").first).to eq([])
    expect(names('!"lightning bolt"').first).to eq([ "Lightning Bolt" ])
    expect(names("forests").first).to eq([ "Forest's Edge" ])
  end

  it "supports negation, or and parentheses" do
    expect(names("t:creature c:r").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("t:instant or t:land").first).to eq([ "Forest's Edge", "Lightning Bolt" ])
    expect(names("-t:creature -t:land").first).to eq([ "Lightning Bolt" ])
    expect(names("t:creature (c:r or c:g) -t:goblin").first).to eq([ "Grizzly Bears" ])
  end

  it "compares colors" do
    expect(names("c:c").first).to eq([ "Forest's Edge" ])
    expect(names("c=rg").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("c:m").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("ci<=rg").first.size).to eq(4)
    expect(names("c>=r").first).to eq([ "Burning-Tree Emissary", "Lightning Bolt" ])
    expect(names("c>1").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("c:gruul").first).to eq([ "Burning-Tree Emissary" ])
  end

  it "compares mana value, power, toughness" do
    expect(names("mv>=2").first).to eq([ "Burning-Tree Emissary", "Grizzly Bears" ])
    expect(names("mv:odd").first).to eq([ "Lightning Bolt" ])
    expect(names("pow=2 tou=2").first).to eq([ "Burning-Tree Emissary", "Grizzly Bears" ])
    expect(names("pow>=tou").first.size).to eq(2)
  end

  it "searches oracle text without reminder text, and regex" do
    expect(names("o:reminder").first).to eq([])
    expect(names("fo:reminder").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("o:/deals \\d damage/").first).to eq([ "Lightning Bolt" ])
  end

  it "searches mana costs" do
    expect(names("m:{R/G}{R/G}").first).to eq([ "Burning-Tree Emissary" ])
    expect(names("m:1g").first).to eq([ "Grizzly Bears" ])
    expect(names("m=g").first).to eq([])
    expect(names("is:hybrid").first).to eq([ "Burning-Tree Emissary" ])
  end

  it "reports unsupported terms and ignores them" do
    names, ignored = names("t:land r:rare price>3")
    expect(names).to eq([ "Forest's Edge" ])
    expect(ignored).to eq([ "r:rare", "price>3" ])
  end

  it "ignores unsafe or invalid regexes" do
    expect(names("o:/(/").second).to eq([ "o:/(/" ])
    expect(names("o:/(?=a)/").second).to eq([ "o:/(?=a)/" ])
  end
end
