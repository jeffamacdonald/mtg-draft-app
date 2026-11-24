# Pads the Garfield cube with synthetic cards up to a production-sized cube
# (700 cards) so dev pages and performance baselines reflect real-world sizes.
# Deterministic: the same cards are generated on every run.
TARGET_CUBE_SIZE = 700
# Filler cards are not real, so give them a link up front: otherwise the card modal asks the Scryfall API and 404s.
SCRYFALL_URI = "https://scryfall.com/"
IMAGE = "https://cards.scryfall.io/normal/front/5/b/5b6ddce7-b9c5-431d-a0b0-46d4aa93cbcb.jpg?1559591324"

rng = Random.new(42)
existing = CubeCard.where(cube_id: cubes.garfield_cube.id).count
needed = TARGET_CUBE_SIZE - existing

# identity => share of the filler cards
shares = {
  [ "W" ] => 14, [ "U" ] => 14, [ "B" ] => 14, [ "R" ] => 14, [ "G" ] => 14,
  [ "W", "U" ] => 3, [ "B", "R" ] => 3, [ "G", "W" ] => 3, [ "U", "B" ] => 3, [ "R", "G" ] => 3,
  [ "W", "U", "B" ] => 2, [ "B", "R", "G" ] => 2,
  [ "C" ] => 6, [ "L" ] => 5
}
total_share = shares.values.sum
spells = [ "Creature", "Creature", "Creature", "Instant", "Sorcery", "Enchantment", "Artifact" ]
text_pool = [
  "Flying", "Trample", "Haste", "Vigilance", "Deathtouch",
  "When this creature enters, draw a card.",
  "Whenever you cast a spell, put a +1/+1 counter on target creature you control.",
  "Destroy target creature with mana value 3 or less. You gain 2 life.",
  "At the beginning of your upkeep, scry 1, then you may sacrifice a permanent to create a Treasure token.",
  "Choose one — Counter target spell unless its controller pays {3}; or return target nonland permanent to its owner's hand."
]

# Integer share per identity; any rounding remainder goes to the first (mono-white) entry
counts = shares.transform_values { |share| needed * share / total_share }
counts[shares.keys.first] += needed - counts.values.sum

n = 0
counts.each do |identity, count|
  count.times do
    n += 1
    key = :"filler_#{n}"
    land = identity == [ "L" ]
    cmc = land ? 0 : rng.rand(1..7)
    type_line = land ? "Land" : spells.sample(random: rng)
    type_line = "Creature — Test Creature" if type_line == "Creature"
    text = land ? "{T}: Add {#{identity.first == 'L' ? 'C' : identity.first}}." : text_pool.sample(rng.rand(1..3), random: rng).join("\n")
    cards.create(
      key,
      name: "Filler #{identity.join}#{n.to_s.rjust(3, '0')}",
      cost: land ? nil : "{#{cmc}}",
      cmc: cmc,
      color_identity: identity,
      type_line: type_line,
      card_text: text,
      layout: "normal",
      default_image: IMAGE,
      default_set: "tst",
      scryfall_uri: SCRYFALL_URI
    )
    cube_cards.create(
      key,
      card: cards.public_send(key),
      cube: cubes.garfield_cube,
      count: 1,
      custom_cmc: cmc,
      custom_color_identity: identity,
      custom_image: IMAGE,
      custom_set: "tst"
    )
  end
end
