# users
users = 10.times.map do
	FactoryBot.create(:user)
end

# cards
white_cards = ["Abeyance","Abolish","Afterlife","Alarum","Allay","Alms","Anoint","Archangel","Armageddon"].map do |name|
	FactoryBot.create(:card, color_identity: ["W"], name:)
end
blue_cards = ["Abduction","Abjure","Acquire","Agoraphobia","Ambiguity","Amnesia","Annex","Annul","Anticipate","Apathy"].map do |name|
	FactoryBot.create(:card, color_identity: ["U"], name:)
end
black_cards = ["Abomination","Addle","Afflict","Annihilate","Asphyxiate","Assassinate","Attrition","Banshee","Befoul","Blackmail"].map do |name|
	FactoryBot.create(:card, color_identity: ["B"], name:)
end
red_cards = ["Abrade","Accelerate","Aftershock","Aggravate","Aggression","Agility","Aleatory","Ambush","Amok","Anarchist"].map do |name|
	FactoryBot.create(:card, color_identity: ["R"], name:)
end
green_cards = ["Ambuscade","Anaconda","Asceticism","Audacity","Aurochs","Awakening","Bequeathal","Berserk","Bifurcate","Bind"].map do |name|
	FactoryBot.create(:card, color_identity: ["G"], name:)
end
colorless_cards = ["Soliton","Tangleroot","Aeolipile","Arachnoid","Astrolabe","Brainstone","Bullwhip","Caltrops","Campfire","Duplicant"].map do |name|
	FactoryBot.create(:card, color_identity: ["C"], name:)
end
gold_cards = ["Absorb","Glaciers","Moderation","Overrule","Rarity","Reparations","Blink","Counterpoint","Lobotomy","Perplex"].map do |name|
	FactoryBot.create(:card, color_identity: ["W","U"], name:)
end
land_cards = ["Karoo","Plains","Island","Everglades","Swamp","Mountain","Forest","Study","Tundra","Badlands"].map do |name|
	FactoryBot.create(:card, type_line: "Land", name:)
end

# cube
cube = FactoryBot.create(:cube, user: users.first)

# cube_cards
white_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
blue_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
black_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
red_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
green_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
colorless_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
gold_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end
land_cards.each do |card|
	FactoryBot.create(:cube_card, card:, cube:, color_identity: card.color_identity.color_identities)
end

# draft
draft = FactoryBot.create(:draft, cube:, owner: users.first)

# draft participants
users.each do |user|
	FactoryBot.create(:draft_participant, draft:, user:, draft_position: nil)
end
