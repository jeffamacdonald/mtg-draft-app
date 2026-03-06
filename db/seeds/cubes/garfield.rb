cubes.create(
  :garfield_cube,
  name: "Garfield Cube",
  owner: users.garfield
)

# CREATE CARDS AND CUBE CARDS
# Armageddon
cards.create(
  :armageddon,
  name: "Armageddon",
  cost: "{3}{W}",
  cmc: 4,
  color_identity: ["W"],
  type_line: "Sorcery",
  card_text: "Destroy all lands.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/5/b/5b6ddce7-b9c5-431d-a0b0-46d4aa93cbcb.jpg?1559591324",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/a25/5/armageddon?utm_source=api")
cube_cards.create(
  :armageddon,
  card: cards.armageddon,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.armageddon.cmc,
  custom_color_identity: cards.armageddon.color_identity.color_identities,
  custom_image: cards.armageddon.default_image,
  custom_set: cards.armageddon.default_set
)
# Righteous Confluence
cards.create(
  :righteous_confluence,
  name: "Righteous Confluence",
  cost: "{3}{W}{W}",
  cmc: 5,
  color_identity: ["W"],
  type_line: "Sorcery",
  card_text: "Choose three. You may choose the same mode more than once.\n• Create a 2/2 white Knight creature token with vigilance.\n• Exile target enchantment.\n• You gain 5 life.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/c/a/ca3b9184-938f-4732-977c-8fb094730384.jpg?1562709612",
  default_set: "c15",
  scryfall_uri: "https://scryfall.com/card/cmm/53/righteous-confluence?utm_source=api")
cube_cards.create(
  :righteous_confluence,
  card: cards.righteous_confluence,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.righteous_confluence.cmc,
  custom_color_identity: cards.righteous_confluence.color_identity.color_identities,
  custom_image: cards.righteous_confluence.default_image,
  custom_set: cards.righteous_confluence.default_set
)
# Sun Titan
cards.create(
  :sun_titan,
  name: "Sun Titan",
  cost: "{4}{W}{W}",
  cmc: 6,
  color_identity: ["W"],
  type_line: "Creature — Giant",
  card_text: "Vigilance\nWhenever Sun Titan enters the battlefield or attacks, you may return target permanent card with mana value 3 or less from your graveyard to the battlefield.",
  layout: "normal",
  power: 6,
  toughness: 6,
  default_image: "https://cards.scryfall.io/normal/front/d/8/d8db2b8e-dce9-49b7-833f-381ee55288cb.jpg?1562477599",
  default_set: "m11",
  scryfall_uri: "https://scryfall.com/card/tdc/133/sun-titan?utm_source=api"
)
cube_cards.create(
  :sun_titan,
  card: cards.sun_titan,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.sun_titan.cmc,
  custom_color_identity: cards.sun_titan.color_identity.color_identities,
  custom_image: cards.sun_titan.default_image,
  custom_set: cards.sun_titan.default_set
)

# Elspeth, Sun's Champion
cards.create(
  :elspeth_suns_champion,
  name: "Elspeth, Sun's Champion",
  cost: "{4}{W}{W}",
  cmc: 6,
  color_identity: ["W"],
  type_line: "Legendary Planeswalker — Elspeth",
  card_text: "+1: Create three 1/1 white Soldier creature tokens.\n−3: Destroy all creatures with power 4 or greater.\n���7: You get an emblem with \"Creatures you control get +2/+2 and have flying.\"",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/f/d/fd5b1633-c41d-42b1-af1b-4a872077ffbd.jpg?1562839369",
  default_set: "ths",
  scryfall_uri: "https://scryfall.com/card/mkc/62/elspeth-suns-champion?utm_source=api"
)
cube_cards.create(
  :elspeth_suns_champion,
  card: cards.elspeth_suns_champion,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.elspeth_suns_champion.cmc,
  custom_color_identity: cards.elspeth_suns_champion.color_identity.color_identities,
  custom_image: cards.elspeth_suns_champion.default_image,
  custom_set: cards.elspeth_suns_champion.default_set
)

# Skrelv, Defector Mite
cards.create(
  :skrelv_defector_mite,
  name: "Skrelv, Defector Mite",
  cost: "{W}",
  cmc: 1,
  color_identity: ["W"],
  type_line: "Legendary Artifact Creature — Phyrexian Mite",
  card_text: "Toxic 1 (Players dealt combat damage by this creature also get a poison counter.)\nSkrelv can't block.\n{W/P}, {T}: Choose a color. Another target creature you control gains toxic 1 and hexproof from that color until end of turn. It can't be blocked by creatures of that color this turn. ({W/P} can be paid with either {W} or 2 life.)",
  layout: "normal",
  power: 1,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/5/0/509c00d2-6a84-4760-8927-483ed123b05f.jpg?1741620346",
  default_set: "sld",
  scryfall_uri: "https://scryfall.com/card/sld/1926/skrelv-defector-mite?utm_source=api"
)
cube_cards.create(
  :skrelv_defector_mite,
  card: cards.skrelv_defector_mite,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.skrelv_defector_mite.cmc,
  custom_color_identity: cards.skrelv_defector_mite.color_identity.color_identities,
  custom_image: cards.skrelv_defector_mite.default_image,
  custom_set: cards.skrelv_defector_mite.default_set
)

# Ultima
cards.create(
  :ultima,
  name: "Ultima",
  cost: "{3}{W}{W}",
  cmc: 5,
  color_identity: ["W"],
  type_line: "Sorcery",
  card_text: "Destroy all artifacts and creatures. End the turn. (Exile all spells and abilities from the stack, including this card. The player whose turn it is discards down to their maximum hand size. Damage wears off, and \"this turn\" and \"until end of turn\" effects end.)",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/3/9/39504a0e-f63f-4907-afd7-c4492f6b8a3b.jpg?1748705896",
  default_set: "fin",
  scryfall_uri: "https://scryfall.com/card/fin/38/ultima?utm_source=api"
)
cube_cards.create(
  :ultima,
  card: cards.ultima,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.ultima.cmc,
  custom_color_identity: cards.ultima.color_identity.color_identities,
  custom_image: cards.ultima.default_image,
  custom_set: cards.ultima.default_set
)

# Aang's Iceberg
cards.create(
  :aangs_iceberg,
  name: "Aang's Iceberg",
  cost: "{2}{W}",
  cmc: 3,
  color_identity: ["W"],
  type_line: "Enchantment",
  card_text: "Flash\nWhen this enchantment enters, exile up to one other target nonland permanent until this enchantment leaves the battlefield.\nWaterbend {3}: Sacrifice this enchantment. If you do, scry 2. (While paying a waterbend cost, you can tap your artifacts and creatures to help. Each one pays for {1}.)",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/7/2/720fbd87-b1c1-4b3b-97a1-46b943b115e3.jpg?1764119900",
  default_set: "tla",
  scryfall_uri: "https://scryfall.com/card/tla/5/aangs-iceberg?utm_source=api"
)
cube_cards.create(
  :aangs_iceberg,
  card: cards.aangs_iceberg,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.aangs_iceberg.cmc,
  custom_color_identity: cards.aangs_iceberg.color_identity.color_identities,
  custom_image: cards.aangs_iceberg.default_image,
  custom_set: cards.aangs_iceberg.default_set
)

# Balance
cards.create(
  :balance,
  name: "Balance",
  cost: "{1}{W}",
  cmc: 2,
  color_identity: ["W"],
  type_line: "Sorcery",
  card_text: "Each player chooses a number of lands they control equal to the number of lands controlled by the player who controls the fewest, then sacrifices the rest. Players discard cards and sacrifice creatures the same way.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/6/f/6f9ea46a-411f-40ce-a873-a905180093f4.jpg?1559591470",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/ema/2/balance?utm_source=api"
)
cube_cards.create(
  :balance,
  card: cards.balance,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.balance.cmc,
  custom_color_identity: cards.balance.color_identity.color_identities,
  custom_image: cards.balance.default_image,
  custom_set: cards.balance.default_set
)

# The Wandering Emperor
cards.create(
  :the_wandering_emperor,
  name: "The Wandering Emperor",
  cost: "{2}{W}{W}",
  cmc: 4,
  color_identity: ["W"],
  type_line: "Legendary Planeswalker",
  card_text: "Flash\nAs long as The Wandering Emperor entered the battlefield this turn, you may activate her loyalty abilities any time you could cast an instant.\n+1: Put a +1/+1 counter on up to one target creature. It gains first strike until end of turn.\n−1: Create a 2/2 white Samurai creature token with vigilance.\n−2: Exile target tapped creature. You gain 2 life.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/f/a/fab2d8a9-ab4c-4225-a570-22636293c17d.jpg?1654566563",
  default_set: "neo",
  scryfall_uri: "https://scryfall.com/card/neo/42/the-wandering-emperor?utm_source=api"
)
cube_cards.create(
  :the_wandering_emperor,
  card: cards.the_wandering_emperor,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.the_wandering_emperor.cmc,
  custom_color_identity: cards.the_wandering_emperor.color_identity.color_identities,
  custom_image: cards.the_wandering_emperor.default_image,
  custom_set: cards.the_wandering_emperor.default_set
)

# Kytheon, Hero of Akros
cards.create(
  :kytheon_hero_of_akros,
  name: "Kytheon, Hero of Akros",
  cost: "{W}",
  cmc: 1,
  color_identity: ["W"],
  type_line: "Legendary Creature — Human Soldier",
  card_text: "At end of combat, if Kytheon, Hero of Akros and at least two other creatures attacked this combat, exile Kytheon, then return him to the battlefield transformed under his owner's control.\n{2}{W}: Kytheon gains indestructible until end of turn.\n+2: Up to one target creature an opponent controls attacks Gideon, Battle-Forged during its controller's next turn if able.\n+1: Until your next turn, target creature gains indestructible. Untap that creature.\n0: Until end of turn, Gideon, Battle-Forged becomes a 4/4 Human Soldier creature with indestructible that's still a planeswalker. Prevent all damage that would be dealt to him this turn.",
  layout: "transform",
  power: 2,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/5/8/58c39df6-b237-40d1-bdcb-2fe5d05392a9.jpg?1562021001",
  default_set: "ori",
  scryfall_uri: "https://scryfall.com/card/ori/23/kytheon-hero-of-akros-gideon-battle-forged?utm_source=api"
)
cube_cards.create(
  :kytheon_hero_of_akros,
  card: cards.kytheon_hero_of_akros,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.kytheon_hero_of_akros.cmc,
  custom_color_identity: cards.kytheon_hero_of_akros.color_identity.color_identities,
  custom_image: cards.kytheon_hero_of_akros.default_image,
  custom_set: cards.kytheon_hero_of_akros.default_set
)

# Mystical Tutor
cards.create(
  :mystical_tutor,
  name: "Mystical Tutor",
  cost: "{U}",
  cmc: 1,
  color_identity: ["U"],
  type_line: "Instant",
  card_text: "Search your library for an instant or sorcery card, reveal it, then shuffle and put that card on top.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/5/d/5d98101f-e32a-4a4a-a649-faa920d111ee.jpg?1562719293",
  default_set: "mir",
  scryfall_uri: "https://scryfall.com/card/dmr/60/mystical-tutor?utm_source=api"
)
cube_cards.create(
  :mystical_tutor,
  card: cards.mystical_tutor,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.mystical_tutor.cmc,
  custom_color_identity: cards.mystical_tutor.color_identity.color_identities,
  custom_image: cards.mystical_tutor.default_image,
  custom_set: cards.mystical_tutor.default_set
)

# Midnight Clock
cards.create(
  :midnight_clock,
  name: "Midnight Clock",
  cost: "{2}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Artifact",
  card_text: "{T}: Add {U}.\n{2}{U}: Put an hour counter on this artifact.\nAt the beginning of each upkeep, put an hour counter on this artifact.\nWhen the twelfth hour counter is put on this artifact, shuffle your hand and graveyard into your library, then draw seven cards. Exile this artifact.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/0/f/0f7f1148-7b1b-4969-a2f8-428de1e2e8ff.jpg?1572489934",
  default_set: "eld",
  scryfall_uri: "https://scryfall.com/card/eld/54/midnight-clock?utm_source=api"
)
cube_cards.create(
  :midnight_clock,
  card: cards.midnight_clock,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.midnight_clock.cmc,
  custom_color_identity: cards.midnight_clock.color_identity.color_identities,
  custom_image: cards.midnight_clock.default_image,
  custom_set: cards.midnight_clock.default_set
)

# Vendilion Clique
cards.create(
  :vendilion_clique,
  name: "Vendilion Clique",
  cost: "{1}{U}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Legendary Creature — Faerie Wizard",
  card_text: "Flash\nFlying\nWhen Vendilion Clique enters the battlefield, look at target player's hand. You may choose a nonland card from it. If you do, that player reveals the chosen card, puts it on the bottom of their library, then draws a card.",
  layout: "normal",
  power: 3,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/f/5/f53d8540-fb6d-4d4c-b467-ebfbfa53c880.jpg?1562882446",
  default_set: "mor",
  scryfall_uri: "https://scryfall.com/card/a25/76/vendilion-clique?utm_source=api"
)
cube_cards.create(
  :vendilion_clique,
  card: cards.vendilion_clique,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.vendilion_clique.cmc,
  custom_color_identity: cards.vendilion_clique.color_identity.color_identities,
  custom_image: cards.vendilion_clique.default_image,
  custom_set: cards.vendilion_clique.default_set
)

# Brainsurge
cards.create(
  :brainsurge,
  name: "Brainsurge",
  cost: "{2}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Instant",
  card_text: "Draw four cards, then put two cards from your hand on top of your library in any order.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/e/d/ed48f805-b57c-4d7f-a3c2-d16ae71bce2d.jpg?1717011631",
  default_set: "mh3",
  scryfall_uri: "https://scryfall.com/card/mh3/53/brainsurge?utm_source=api"
)
cube_cards.create(
  :brainsurge,
  card: cards.brainsurge,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.brainsurge.cmc,
  custom_color_identity: cards.brainsurge.color_identity.color_identities,
  custom_image: cards.brainsurge.default_image,
  custom_set: cards.brainsurge.default_set
)
# Master of Etherium
cards.create(
  :master_of_etherium,
  name: "Master of Etherium",
  cost: "{2}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Artifact Creature — Vedalken Wizard",
  card_text: "Master of Etherium's power and toughness are each equal to the number of artifacts you control.\nOther artifact creatures you control get +1/+1.",
  layout: "normal",
  power: 0,
  toughness: 0,
  default_image: "https://cards.scryfall.io/normal/front/3/2/322cdf67-5b36-43f9-99b3-f0e24d423314.jpg?1562702574",
  default_set: "ala",
  scryfall_uri: "https://scryfall.com/card/moc/226/master-of-etherium?utm_source=api"
)
cube_cards.create(
  :master_of_etherium,
  card: cards.master_of_etherium,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.master_of_etherium.cmc,
  custom_color_identity: cards.master_of_etherium.color_identity.color_identities,
  custom_image: cards.master_of_etherium.default_image,
  custom_set: cards.master_of_etherium.default_set
)

# Phyrexian Metamorph
cards.create(
  :phyrexian_metamorph,
  name: "Phyrexian Metamorph",
  cost: "{3}{U/P}",
  cmc: 4,
  color_identity: ["U"],
  type_line: "Artifact Creature — Phyrexian Shapeshifter",
  card_text: "({U/P} can be paid with either {U} or 2 life.)\nYou may have Phyrexian Metamorph enter the battlefield as a copy of any artifact or creature on the battlefield, except it's an artifact in addition to its other types.",
  layout: "normal",
  power: 0,
  toughness: 0,
  default_image: "https://cards.scryfall.io/normal/front/d/2/d2e27911-87cb-49a0-a34f-6afe4bddd592.jpg?1562881786",
  default_set: "nph",
  scryfall_uri: "https://scryfall.com/card/mkc/116/phyrexian-metamorph?utm_source=api"
)
cube_cards.create(
  :phyrexian_metamorph,
  card: cards.phyrexian_metamorph,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.phyrexian_metamorph.cmc,
  custom_color_identity: cards.phyrexian_metamorph.color_identity.color_identities,
  custom_image: cards.phyrexian_metamorph.default_image,
  custom_set: cards.phyrexian_metamorph.default_set
)

# Thieving Skydiver
cards.create(
  :thieving_skydiver,
  name: "Thieving Skydiver",
  cost: "{1}{U}",
  cmc: 2,
  color_identity: ["U"],
  type_line: "Creature — Merfolk Rogue",
  card_text: "Kicker {X}. X can't be 0. (You may pay an additional {X} as you cast this spell.)\nFlying\nWhen Thieving Skydiver enters the battlefield, if it was kicked, gain control of target artifact with mana value X or less. If that artifact is an Equipment, attach it to Thieving Skydiver.",
  layout: "normal",
  power: 2,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/f/f/ff84ea71-e477-44f7-a3f8-77fef708efeb.jpg?1604195053",
  default_set: "znr",
  scryfall_uri: "https://scryfall.com/card/otc/118/thieving-skydiver?utm_source=api"
)
cube_cards.create(
  :thieving_skydiver,
  card: cards.thieving_skydiver,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.thieving_skydiver.cmc,
  custom_color_identity: cards.thieving_skydiver.color_identity.color_identities,
  custom_image: cards.thieving_skydiver.default_image,
  custom_set: cards.thieving_skydiver.default_set
)

# Consult the Star Charts
cards.create(
  :consult_the_star_charts,
  name: "Consult the Star Charts",
  cost: "{1}{U}",
  cmc: 2,
  color_identity: ["U"],
  type_line: "Instant",
  card_text: "Kicker {1}{U} (You may pay an additional {1}{U} as you cast this spell.)\nLook at the top X cards of your library, where X is the number of lands you control. Put one of those cards into your hand. If this spell was kicked, put two of those cards into your hand instead. Put the rest on the bottom of your library in a random order.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/a/1/a16a6555-2e3a-4587-aacd-0307d696b26c.jpg?1752946753",
  default_set: "eoe",
  scryfall_uri: "https://scryfall.com/card/eoe/51/consult-the-star-charts?utm_source=api"
)
cube_cards.create(
  :consult_the_star_charts,
  card: cards.consult_the_star_charts,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.consult_the_star_charts.cmc,
  custom_color_identity: cards.consult_the_star_charts.color_identity.color_identities,
  custom_image: cards.consult_the_star_charts.default_image,
  custom_set: cards.consult_the_star_charts.default_set
)

# Confounding Riddle
cards.create(
  :confounding_riddle,
  name: "Confounding Riddle",
  cost: "{2}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Instant",
  card_text: "Choose one —\n• Look at the top four cards of your library. Put one of them into your hand and the rest into your graveyard.\n• Counter target spell unless its controller pays {4}.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/f/2/f2ae23db-c391-402c-9568-65447cada66e.jpg?1699043580",
  default_set: "lci",
  scryfall_uri: "https://scryfall.com/card/lci/50/confounding-riddle?utm_source=api"
)
cube_cards.create(
  :confounding_riddle,
  card: cards.confounding_riddle,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.confounding_riddle.cmc,
  custom_color_identity: cards.confounding_riddle.color_identity.color_identities,
  custom_image: cards.confounding_riddle.default_image,
  custom_set: cards.confounding_riddle.default_set
)

# Thirst for Identity
cards.create(
  :thirst_for_identity,
  name: "Thirst for Identity",
  cost: "{2}{U}",
  cmc: 3,
  color_identity: ["U"],
  type_line: "Instant",
  card_text: "Draw three cards. Then discard two cards unless you discard a creature card.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/c/3/c3949f8c-d1c5-45c2-80ed-a57f4f9af86e.jpg?1767957051",
  default_set: "ecl",
  scryfall_uri: "https://scryfall.com/card/ecl/79/thirst-for-identity?utm_source=api"
)
cube_cards.create(
  :thirst_for_identity,
  card: cards.thirst_for_identity,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.thirst_for_identity.cmc,
  custom_color_identity: cards.thirst_for_identity.color_identity.color_identities,
  custom_image: cards.thirst_for_identity.default_image,
  custom_set: cards.thirst_for_identity.default_set
)
# Bone Shards
cards.create(
  :bone_shards,
  name: "Bone Shards",
  cost: "{B}",
  cmc: 1,
  color_identity: ["B"],
  type_line: "Sorcery",
  card_text: "As an additional cost to cast this spell, sacrifice a creature or discard a card.\nDestroy target creature or planeswalker.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/1/e/1ee98955-4c47-4d45-9377-608dfa755337.jpg?1626095299",
  default_set: "mh2",
  scryfall_uri: "https://scryfall.com/card/mh2/76/bone-shards?utm_source=api"
)
cube_cards.create(
  :bone_shards,
  card: cards.bone_shards,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.bone_shards.cmc,
  custom_color_identity: cards.bone_shards.color_identity.color_identities,
  custom_image: cards.bone_shards.default_image,
  custom_set: cards.bone_shards.default_set
)

# Phyrexian Arena
cards.create(
  :phyrexian_arena,
  name: "Phyrexian Arena",
  cost: "{1}{B}{B}",
  cmc: 3,
  color_identity: ["B"],
  type_line: "Enchantment",
  card_text: "At the beginning of your upkeep, you draw a card and you lose 1 life.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/8/4/84e19975-e3e1-453b-b902-a1b1fc1d8504.jpg?1562926298",
  default_set: "apc",
  scryfall_uri: "https://scryfall.com/card/apc/47/phyrexian-arena?utm_source=api"
)
cube_cards.create(
  :phyrexian_arena,
  card: cards.phyrexian_arena,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.phyrexian_arena.cmc,
  custom_color_identity: cards.phyrexian_arena.color_identity.color_identities,
  custom_image: cards.phyrexian_arena.default_image,
  custom_set: cards.phyrexian_arena.default_set
)

# Demonic Tutor
cards.create(
  :demonic_tutor,
  name: "Demonic Tutor",
  cost: "{1}{B}",
  cmc: 2,
  color_identity: ["B"],
  type_line: "Sorcery",
  card_text: "Search your library for a card, put that card into your hand, then shuffle.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/7/1/711d4d54-5520-4de8-9b93-79902ed8e562.jpg?1559591474",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/cmm/150/demonic-tutor?utm_source=api"
)
cube_cards.create(
  :demonic_tutor,
  card: cards.demonic_tutor,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.demonic_tutor.cmc,
  custom_color_identity: cards.demonic_tutor.color_identity.color_identities,
  custom_image: cards.demonic_tutor.default_image,
  custom_set: cards.demonic_tutor.default_set
)
# The Abyss
cards.create(
  :the_abyss,
  name: "The Abyss",
  cost: "{3}{B}",
  cmc: 4,
  color_identity: ["B"],
  type_line: "World Enchantment",
  card_text: "At the beginning of each player's upkeep, destroy target nonartifact creature that player controls of their choice. It can't be regenerated.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/8/6/86a27d68-3e58-4ade-976d-36381beed451.jpg?1592364435",
  default_set: "leg",
  scryfall_uri: "https://scryfall.com/card/me3/77/the-abyss?utm_source=api"
)
cube_cards.create(
  :the_abyss,
  card: cards.the_abyss,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.the_abyss.cmc,
  custom_color_identity: cards.the_abyss.color_identity.color_identities,
  custom_image: cards.the_abyss.default_image,
  custom_set: cards.the_abyss.default_set
)

# Liliana of the Veil
cards.create(
  :liliana_of_the_veil,
  name: "Liliana of the Veil",
  cost: "{1}{B}{B}",
  cmc: 3,
  color_identity: ["B"],
  type_line: "Legendary Planeswalker — Liliana",
  card_text: "+1: Each player discards a card.\n−2: Target player sacrifices a creature.\n−6: Separate all permanents target player controls into two piles. That player sacrifices all permanents in the pile of their choice.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/a/c/ac506c17-adc8-49c6-9d8d-43db7cb1ec9d.jpg?1562835390",
  default_set: "isd",
  scryfall_uri: "https://scryfall.com/card/dmu/97/liliana-of-the-veil?utm_source=api"
)
cube_cards.create(
  :liliana_of_the_veil,
  card: cards.liliana_of_the_veil,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.liliana_of_the_veil.cmc,
  custom_color_identity: cards.liliana_of_the_veil.color_identity.color_identities,
  custom_image: cards.liliana_of_the_veil.default_image,
  custom_set: cards.liliana_of_the_veil.default_set
)

# Animate Dead
cards.create(
  :animate_dead,
  name: "Animate Dead",
  cost: "{1}{B}",
  cmc: 2,
  color_identity: ["B"],
  type_line: "Enchantment — Aura",
  card_text: "Enchant creature card in a graveyard\nWhen Animate Dead enters the battlefield, if it's on the battlefield, it loses \"enchant creature card in a graveyard\" and gains \"enchant creature put onto the battlefield with Animate Dead.\" Return enchanted creature card to the battlefield under your control and attach Animate Dead to it. When Animate Dead leaves the battlefield, that creature's controller sacrifices it.\nEnchanted creature gets -1/-0.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/8/f/8fd7861d-925f-4b4c-a4ab-60be6f43d50b.jpg?1559591550",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/mkc/125/animate-dead?utm_source=api"
)
cube_cards.create(
  :animate_dead,
  card: cards.animate_dead,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.animate_dead.cmc,
  custom_color_identity: cards.animate_dead.color_identity.color_identities,
  custom_image: cards.animate_dead.default_image,
  custom_set: cards.animate_dead.default_set
)

# Urborg Scavengers
cards.create(
  :urborg_scavengers,
  name: "Urborg Scavengers",
  cost: "{2}{B}",
  cmc: 3,
  color_identity: ["B"],
  type_line: "Creature — Spirit",
  card_text: "Whenever Urborg Scavengers enters the battlefield or attacks, exile target card from a graveyard. Put a +1/+1 counter on Urborg Scavengers.\nUrborg Scavengers has flying as long as a card exiled with it has flying. The same is true for first strike, double strike, deathtouch, haste, hexproof, indestructible, lifelink, menace, reach, trample, and vigilance.",
  layout: "normal",
  power: 2,
  toughness: 2,
  default_image: "https://cards.scryfall.io/normal/front/4/d/4dbb4d8f-8ae3-4052-9c6a-e56e96cec832.jpg?1684340572",
  default_set: "mat",
  scryfall_uri: "https://scryfall.com/card/mat/15/urborg-scavengers?utm_source=api"
)
cube_cards.create(
  :urborg_scavengers,
  card: cards.urborg_scavengers,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.urborg_scavengers.cmc,
  custom_color_identity: cards.urborg_scavengers.color_identity.color_identities,
  custom_image: cards.urborg_scavengers.default_image,
  custom_set: cards.urborg_scavengers.default_set
)

# Dismember
cards.create(
  :dismember,
  name: "Dismember",
  cost: "{1}{B/P}{B/P}",
  cmc: 3,
  color_identity: ["B"],
  type_line: "Instant",
  card_text: "({B/P} can be paid with either {B} or 2 life.)\nTarget creature gets -5/-5 until end of turn.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/0/6/064dfdeb-485f-473e-9fa0-8fdb7638cdc6.jpg?1562875311",
  default_set: "nph",
  scryfall_uri: "https://scryfall.com/card/mm2/79/dismember?utm_source=api"
)
cube_cards.create(
  :dismember,
  card: cards.dismember,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.dismember.cmc,
  custom_color_identity: cards.dismember.color_identity.color_identities,
  custom_image: cards.dismember.default_image,
  custom_set: cards.dismember.default_set
)

# Snuff Out
cards.create(
  :snuff_out,
  name: "Snuff Out",
  cost: "{3}{B}",
  cmc: 4,
  color_identity: ["B"],
  type_line: "Instant",
  card_text: "If you control a Swamp, you may pay 4 life rather than pay this spell's mana cost.\nDestroy target nonblack creature. It can't be regenerated.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/1/8/18a3cca1-e50e-49b6-9e1a-f86640e3b177.jpg?1562379436",
  default_set: "mmq",
  scryfall_uri: "https://scryfall.com/card/mmq/162/snuff-out?utm_source=api"
)
cube_cards.create(
  :snuff_out,
  card: cards.snuff_out,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.snuff_out.cmc,
  custom_color_identity: cards.snuff_out.color_identity.color_identities,
  custom_image: cards.snuff_out.default_image,
  custom_set: cards.snuff_out.default_set
)

# The Soul Stone
cards.create(
  :the_soul_stone,
  name: "The Soul Stone",
  cost: "{1}{B}",
  cmc: 2,
  color_identity: ["B"],
  type_line: "Legendary Artifact — Infinity Stone",
  card_text: "Indestructible\n{T}: Add {B}.\n{6}{B}, {T}, Exile a creature you control: Harness The Soul Stone. (Once harnessed, its ∞ ability is active.)\n∞ — At the beginning of your upkeep, return target creature card from your graveyard to the battlefield.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/1/9/1982f910-a9bd-4e94-a187-84381b22aacc.jpg?1757377171",
  default_set: "spm",
  scryfall_uri: "https://scryfall.com/card/spm/66/the-soul-stone?utm_source=api"
)
cube_cards.create(
  :the_soul_stone,
  card: cards.the_soul_stone,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.the_soul_stone.cmc,
  custom_color_identity: cards.the_soul_stone.color_identity.color_identities,
  custom_image: cards.the_soul_stone.default_image,
  custom_set: cards.the_soul_stone.default_set
)

# Hellrider
cards.create(
  :hellrider,
  name: "Hellrider",
  cost: "{2}{R}{R}",
  cmc: 4,
  color_identity: ["R"],
  type_line: "Creature — Devil",
  card_text: "Haste\nWhenever a creature you control attacks, Hellrider deals 1 damage to the player or planeswalker it's attacking.",
  layout: "normal",
  power: 3,
  toughness: 3,
  default_image: "https://cards.scryfall.io/normal/front/0/e/0ec8d800-7f06-44e0-b22d-cdff0a9b153d.jpg?1592666042",
  default_set: "dka",
  scryfall_uri: "https://scryfall.com/card/jmp/334/hellrider?utm_source=api"
)
cube_cards.create(
  :hellrider,
  card: cards.hellrider,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.hellrider.cmc,
  custom_color_identity: cards.hellrider.color_identity.color_identities,
  custom_image: cards.hellrider.default_image,
  custom_set: cards.hellrider.default_set
)

# Monastery Swiftspear
cards.create(
  :monastery_swiftspear,
  name: "Monastery Swiftspear",
  cost: "{R}",
  cmc: 1,
  color_identity: ["R"],
  type_line: "Creature — Human Monk",
  card_text: "Haste\nProwess (Whenever you cast a noncreature spell, this creature gets +1/+1 until end of turn.)",
  layout: "normal",
  power: 1,
  toughness: 2,
  default_image: "https://cards.scryfall.io/normal/front/b/8/b81c6c8b-a9cf-4866-89ba-7f8ad077b836.jpg?1562792493",
  default_set: "ktk",
  scryfall_uri: "https://scryfall.com/card/bro/144/monastery-swiftspear?utm_source=api"
)
cube_cards.create(
  :monastery_swiftspear,
  card: cards.monastery_swiftspear,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.monastery_swiftspear.cmc,
  custom_color_identity: cards.monastery_swiftspear.color_identity.color_identities,
  custom_image: cards.monastery_swiftspear.default_image,
  custom_set: cards.monastery_swiftspear.default_set
)

# Siege-Gang Commander
cards.create(
  :siegegang_commander,
  name: "Siege-Gang Commander",
  cost: "{3}{R}{R}",
  cmc: 5,
  color_identity: ["R"],
  type_line: "Creature — Goblin",
  card_text: "When Siege-Gang Commander enters the battlefield, create three 1/1 red Goblin creature tokens.\n{1}{R}, Sacrifice a Goblin: Siege-Gang Commander deals 2 damage to any target.",
  layout: "normal",
  power: 2,
  toughness: 2,
  default_image: "https://cards.scryfall.io/normal/front/9/2/92e78cec-aaf9-4fe8-887b-b7e356d63315.jpg?1562532154",
  default_set: "scg",
  scryfall_uri: "https://scryfall.com/card/dmr/136/siege-gang-commander?utm_source=api"
)
cube_cards.create(
  :siegegang_commander,
  card: cards.siegegang_commander,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.siegegang_commander.cmc,
  custom_color_identity: cards.siegegang_commander.color_identity.color_identities,
  custom_image: cards.siegegang_commander.default_image,
  custom_set: cards.siegegang_commander.default_set
)

# Shatterskull Smashing
cards.create(
  :shatterskull_smashing,
  name: "Shatterskull Smashing",
  cost: "{X}{R}{R}",
  cmc: 3,
  color_identity: ["R"],
  type_line: "Sorcery",
  card_text: "Shatterskull Smashing deals X damage divided as you choose among up to two target creatures and/or planeswalkers. If X is 6 or more, Shatterskull Smashing deals twice X damage divided as you choose among them instead.\nAs Shatterskull, the Hammer Pass enters the battlefield, you may pay 3 life. If you don't, it enters the battlefield tapped.\n{T}: Add {R}.",
  layout: "modal_dfc",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/b/c/bc7239ea-f8aa-4a6f-87bd-c35359635673.jpg?1604197844",
  default_set: "znr",
  scryfall_uri: "https://scryfall.com/card/znr/161/shatterskull-smashing-shatterskull-the-hammer-pass?utm_source=api"
)
cube_cards.create(
  :shatterskull_smashing,
  card: cards.shatterskull_smashing,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.shatterskull_smashing.cmc,
  custom_color_identity: cards.shatterskull_smashing.color_identity.color_identities,
  custom_image: cards.shatterskull_smashing.default_image,
  custom_set: cards.shatterskull_smashing.default_set
)

# Ral, Monsoon Mage
cards.create(
  :ral_monsoon_mage,
  name: "Ral, Monsoon Mage",
  cost: "{1}{R}",
  cmc: 2,
  color_identity: ["R"],
  type_line: "Legendary Creature — Human Wizard",
  card_text: "Instant and sorcery spells you cast cost {1} less to cast.\nWhenever you cast an instant or sorcery spell during your turn, flip a coin. If you lose the flip, Ral deals 1 damage to you. If you win the flip, you may exile Ral. If you do, return him to the battlefield transformed under his owner's control.\nRal enters with an additional loyalty counter on him for each instant and sorcery spell you've cast this turn.\n+1: Until your next turn, instant and sorcery spells you cast cost {1} less to cast.\n−2: Ral deals 2 damage divided as you choose among one or two targets. Draw a card if you control a blue permanent other than Ral.\n−8: Exile the top eight cards of your library. You may cast instant and sorcery spells from among them this turn without paying their mana costs.",
  layout: "transform",
  power: 1,
  toughness: 3,
  default_image: "https://cards.scryfall.io/normal/front/4/3/438d8a26-ddc9-4829-8aff-22d6af6575cf.jpg?1748260617",
  default_set: "mh3",
  scryfall_uri: "https://scryfall.com/card/mh3/247/ral-monsoon-mage-ral-leyline-prodigy?utm_source=api"
)
cube_cards.create(
  :ral_monsoon_mage,
  card: cards.ral_monsoon_mage,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.ral_monsoon_mage.cmc,
  custom_color_identity: cards.ral_monsoon_mage.color_identity.color_identities,
  custom_image: cards.ral_monsoon_mage.default_image,
  custom_set: cards.ral_monsoon_mage.default_set
)

# Magma Jet
cards.create(
  :magma_jet,
  name: "Magma Jet",
  cost: "{1}{R}",
  cmc: 2,
  color_identity: ["R"],
  type_line: "Instant",
  card_text: "Magma Jet deals 2 damage to any target. Scry 2.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/5/1/51ea1728-08aa-4553-90b2-919c70712ed5.jpg?1562877009",
  default_set: "5dn",
  scryfall_uri: "https://scryfall.com/card/jmp/346/magma-jet?utm_source=api"
)
cube_cards.create(
  :magma_jet,
  card: cards.magma_jet,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.magma_jet.cmc,
  custom_color_identity: cards.magma_jet.color_identity.color_identities,
  custom_image: cards.magma_jet.default_image,
  custom_set: cards.magma_jet.default_set
)

# Ghostfire Slice
cards.create(
  :ghostfire_slice,
  name: "Ghostfire Slice",
  cost: "{2}{R}",
  cmc: 3,
  color_identity: ["R"],
  type_line: "Instant",
  card_text: "Devoid (This card has no color.)\nThis spell costs {2} less to cast if an opponent controls a multicolored permanent.\nGhostfire Slice deals 4 damage to any target.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/2/a/2adea3ee-138f-455b-a001-586883c44758.jpg?1720465738",
  default_set: "mh3",
  scryfall_uri: "https://scryfall.com/card/mh3/123/ghostfire-slice?utm_source=api"
)
cube_cards.create(
  :ghostfire_slice,
  card: cards.ghostfire_slice,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.ghostfire_slice.cmc,
  custom_color_identity: cards.ghostfire_slice.color_identity.color_identities,
  custom_image: cards.ghostfire_slice.default_image,
  custom_set: cards.ghostfire_slice.default_set
)

# Pyroclasm
cards.create(
  :pyroclasm,
  name: "Pyroclasm",
  cost: "{1}{R}",
  cmc: 2,
  color_identity: ["R"],
  type_line: "Sorcery",
  card_text: "Pyroclasm deals 2 damage to each creature.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/8/8/88040748-ad76-4b9a-bd4e-87e5980e9816.jpg?1562920179",
  default_set: "ice",
  scryfall_uri: "https://scryfall.com/card/dsk/149/pyroclasm?utm_source=api"
)
cube_cards.create(
  :pyroclasm,
  card: cards.pyroclasm,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.pyroclasm.cmc,
  custom_color_identity: cards.pyroclasm.color_identity.color_identities,
  custom_image: cards.pyroclasm.default_image,
  custom_set: cards.pyroclasm.default_set
)

# Inferno Titan
cards.create(
  :inferno_titan,
  name: "Inferno Titan",
  cost: "{4}{R}{R}",
  cmc: 6,
  color_identity: ["R"],
  type_line: "Creature — Giant",
  card_text: "{R}: Inferno Titan gets +1/+0 until end of turn.\nWhenever Inferno Titan enters the battlefield or attacks, it deals 3 damage divided as you choose among one, two, or three targets.",
  layout: "normal",
  power: 6,
  toughness: 6,
  default_image: "https://cards.scryfall.io/normal/front/f/1/f1e4a028-6462-4373-9864-a8adfc78d52b.jpg?1562480719",
  default_set: "m11",
  scryfall_uri: "https://scryfall.com/card/cmm/235/inferno-titan?utm_source=api"
)
cube_cards.create(
  :inferno_titan,
  card: cards.inferno_titan,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.inferno_titan.cmc,
  custom_color_identity: cards.inferno_titan.color_identity.color_identities,
  custom_image: cards.inferno_titan.default_image,
  custom_set: cards.inferno_titan.default_set
)

# Through the Breach
cards.create(
  :through_the_breach,
  name: "Through the Breach",
  cost: "{4}{R}",
  cmc: 5,
  color_identity: ["R"],
  type_line: "Instant — Arcane",
  card_text: "You may put a creature card from your hand onto the battlefield. That creature gains haste. Sacrifice that creature at the beginning of the next end step.\nSplice onto Arcane {2}{R}{R} (As you cast an Arcane spell, you may reveal this card from your hand and pay its splice cost. If you do, add this card's effects to that spell.)",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/c/9/c90a3430-f6d9-4432-84d3-9952d2b82003.jpg?1736468237",
  default_set: "inr",
  scryfall_uri: "https://scryfall.com/card/inr/175/through-the-breach?utm_source=api"
)
cube_cards.create(
  :through_the_breach,
  card: cards.through_the_breach,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.through_the_breach.cmc,
  custom_color_identity: cards.through_the_breach.color_identity.color_identities,
  custom_image: cards.through_the_breach.default_image,
  custom_set: cards.through_the_breach.default_set
)

# Overlord of the Hauntwoods
cards.create(
  :overlord_of_the_hauntwoods,
  name: "Overlord of the Hauntwoods",
  cost: "{3}{G}{G}",
  cmc: 5,
  color_identity: ["G"],
  type_line: "Enchantment Creature — Avatar Horror",
  card_text: "Impending 4—{1}{G}{G} (If you cast this spell for its impending cost, it enters with four time counters and isn't a creature until the last is removed. At the beginning of your end step, remove a time counter from it.)\nWhenever this permanent enters or attacks, create a tapped colorless land token named Everywhere that is every basic land type.",
  layout: "normal",
  power: 6,
  toughness: 5,
  default_image: "https://cards.scryfall.io/normal/front/0/5/05d08ff1-edcc-4c76-96e0-683b3da36ebb.jpg?1726286590",
  default_set: "dsk",
  scryfall_uri: "https://scryfall.com/card/dsk/194/overlord-of-the-hauntwoods?utm_source=api"
)
cube_cards.create(
  :overlord_of_the_hauntwoods,
  card: cards.overlord_of_the_hauntwoods,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.overlord_of_the_hauntwoods.cmc,
  custom_color_identity: cards.overlord_of_the_hauntwoods.color_identity.color_identities,
  custom_image: cards.overlord_of_the_hauntwoods.default_image,
  custom_set: cards.overlord_of_the_hauntwoods.default_set
)

# Farseek
cards.create(
  :farseek,
  name: "Farseek",
  cost: "{1}{G}",
  cmc: 2,
  color_identity: ["G"],
  type_line: "Sorcery",
  card_text: "Search your library for a Plains, Island, Swamp, or Mountain card, put it onto the battlefield tapped, then shuffle.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/3/d/3dbd7f11-01d2-4bb1-9f49-dd72d1afb3e5.jpg?1673305375",
  default_set: "dmc",
  scryfall_uri: "https://scryfall.com/card/tdc/255/farseek?utm_source=api"
)
cube_cards.create(
  :farseek,
  card: cards.farseek,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.farseek.cmc,
  custom_color_identity: cards.farseek.color_identity.color_identities,
  custom_image: cards.farseek.default_image,
  custom_set: cards.farseek.default_set
)

# Garruk Wildspeaker
cards.create(
  :garruk_wildspeaker,
  name: "Garruk Wildspeaker",
  cost: "{2}{G}{G}",
  cmc: 4,
  color_identity: ["G"],
  type_line: "Legendary Planeswalker — Garruk",
  card_text: "+1: Untap two target lands.\n−1: Create a 3/3 green Beast creature token.\n−4: Creatures you control get +3/+3 and gain trample until end of turn.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/c/a/ca6f13a2-9243-4ce9-9f71-bed74355b781.jpg?1562367767",
  default_set: "lrw",
  scryfall_uri: "https://scryfall.com/card/cmd/157/garruk-wildspeaker?utm_source=api"
)
cube_cards.create(
  :garruk_wildspeaker,
  card: cards.garruk_wildspeaker,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.garruk_wildspeaker.cmc,
  custom_color_identity: cards.garruk_wildspeaker.color_identity.color_identities,
  custom_image: cards.garruk_wildspeaker.default_image,
  custom_set: cards.garruk_wildspeaker.default_set
)

# Fastbond
cards.create(
  :fastbond,
  name: "Fastbond",
  cost: "{G}",
  cmc: 1,
  color_identity: ["G"],
  type_line: "Enchantment",
  card_text: "You may play any number of lands on each of your turns.\nWhenever you play a land, if it wasn't the first land you played this turn, Fastbond deals 1 damage to you.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/a/5/a575a9af-e1de-4a1d-91d8-440585377e4f.jpg?1559591294",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/vma/209/fastbond?utm_source=api"
)
cube_cards.create(
  :fastbond,
  card: cards.fastbond,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.fastbond.cmc,
  custom_color_identity: cards.fastbond.color_identity.color_identities,
  custom_image: cards.fastbond.default_image,
  custom_set: cards.fastbond.default_set
)

# Gilded Goose
cards.create(
  :gilded_goose,
  name: "Gilded Goose",
  cost: "{G}",
  cmc: 1,
  color_identity: ["G"],
  type_line: "Creature — Bird",
  card_text: "Flying\nWhen Gilded Goose enters, create a Food token. (It's an artifact with \"{2}, {T}, Sacrifice this artifact: You gain 3 life.\")\n{1}{G}, {T}: Create a Food token.\n{T}, Sacrifice a Food: Add one mana of any color.",
  layout: "normal",
  power: 0,
  toughness: 2,
  default_image: "https://cards.scryfall.io/normal/front/e/b/eb08b642-aff6-4c37-a952-f8ddcfc4767e.jpg?1599358785",
  default_set: "sld",
  scryfall_uri: "https://scryfall.com/card/moc/299/gilded-goose?utm_source=api"
)
cube_cards.create(
  :gilded_goose,
  card: cards.gilded_goose,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.gilded_goose.cmc,
  custom_color_identity: cards.gilded_goose.color_identity.color_identities,
  custom_image: cards.gilded_goose.default_image,
  custom_set: cards.gilded_goose.default_set
)

# Deranged Hermit
cards.create(
  :deranged_hermit,
  name: "Deranged Hermit",
  cost: "{3}{G}{G}",
  cmc: 5,
  color_identity: ["G"],
  type_line: "Creature — Elf",
  card_text: "Echo {3}{G}{G} (At the beginning of your upkeep, if this came under your control since the beginning of your last upkeep, sacrifice it unless you pay its echo cost.)\nWhen Deranged Hermit enters the battlefield, create four 1/1 green Squirrel creature tokens.\nSquirrel creatures get +1/+1.",
  layout: "normal",
  power: 1,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/b/f/bf0e94c9-61c4-4cc0-b5ce-db62bc2660ee.jpg?1562864220",
  default_set: "ulg",
  scryfall_uri: "https://scryfall.com/card/vma/202/deranged-hermit?utm_source=api"
)
cube_cards.create(
  :deranged_hermit,
  card: cards.deranged_hermit,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.deranged_hermit.cmc,
  custom_color_identity: cards.deranged_hermit.color_identity.color_identities,
  custom_image: cards.deranged_hermit.default_image,
  custom_set: cards.deranged_hermit.default_set
)

# Llanowar Elves
cards.create(
  :llanowar_elves,
  name: "Llanowar Elves",
  cost: "{G}",
  cmc: 1,
  color_identity: ["G"],
  type_line: "Creature — Elf Druid",
  card_text: "{T}: Add {G}.",
  layout: "normal",
  power: 1,
  toughness: 1,
  default_image: "https://cards.scryfall.io/normal/front/d/4/d4f1cc9e-4f99-4c26-ac1b-8ef069fa8ceb.jpg?1559591371",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/fdn/227/llanowar-elves?utm_source=api"
)
cube_cards.create(
  :llanowar_elves,
  card: cards.llanowar_elves,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.llanowar_elves.cmc,
  custom_color_identity: cards.llanowar_elves.color_identity.color_identities,
  custom_image: cards.llanowar_elves.default_image,
  custom_set: cards.llanowar_elves.default_set
)

# Craterhoof Behemoth
cards.create(
  :craterhoof_behemoth,
  name: "Craterhoof Behemoth",
  cost: "{5}{G}{G}{G}",
  cmc: 8,
  color_identity: ["G"],
  type_line: "Creature — Beast",
  card_text: "Haste\nWhen Craterhoof Behemoth enters the battlefield, creatures you control gain trample and get +X/+X until end of turn, where X is the number of creatures you control.",
  layout: "normal",
  power: 5,
  toughness: 5,
  default_image: "https://cards.scryfall.io/normal/front/a/2/a249be17-73ed-4108-89c0-f7e87939beb8.jpg?1592709311",
  default_set: "avr",
  scryfall_uri: "https://scryfall.com/card/tdm/138/craterhoof-behemoth?utm_source=api"
)
cube_cards.create(
  :craterhoof_behemoth,
  card: cards.craterhoof_behemoth,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.craterhoof_behemoth.cmc,
  custom_color_identity: cards.craterhoof_behemoth.color_identity.color_identities,
  custom_image: cards.craterhoof_behemoth.default_image,
  custom_set: cards.craterhoof_behemoth.default_set
)

# Primal Command
cards.create(
  :primal_command,
  name: "Primal Command",
  cost: "{3}{G}{G}",
  cmc: 5,
  color_identity: ["G"],
  type_line: "Sorcery",
  card_text: "Choose two —\n• Target player gains 7 life.\n• Put target noncreature permanent on top of its owner's library.\n• Target player shuffles their graveyard into their library.\n• Search your library for a creature card, reveal it, put it into your hand, then shuffle.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/4/0/40d2c5b9-cef9-4763-8e65-e3b1418c0ad3.jpg?1562345828",
  default_set: "lrw",
  scryfall_uri: "https://scryfall.com/card/mm3/132/primal-command?utm_source=api"
)
cube_cards.create(
  :primal_command,
  card: cards.primal_command,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.primal_command.cmc,
  custom_color_identity: cards.primal_command.color_identity.color_identities,
  custom_image: cards.primal_command.default_image,
  custom_set: cards.primal_command.default_set
)

# Courser of Kruphix
cards.create(
  :courser_of_kruphix,
  name: "Courser of Kruphix",
  cost: "{1}{G}{G}",
  cmc: 3,
  color_identity: ["G"],
  type_line: "Enchantment Creature — Centaur",
  card_text: "Play with the top card of your library revealed.\nYou may play lands from the top of your library.\nLandfall — Whenever a land enters the battlefield under your control, you gain 1 life.",
  layout: "normal",
  power: 2,
  toughness: 4,
  default_image: "https://cards.scryfall.io/normal/front/d/a/da5a807f-58e8-4d92-a61c-47bb9b28977f.jpg?1593092436",
  default_set: "bng",
  scryfall_uri: "https://scryfall.com/card/cmm/888/courser-of-kruphix?utm_source=api"
)
cube_cards.create(
  :courser_of_kruphix,
  card: cards.courser_of_kruphix,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.courser_of_kruphix.cmc,
  custom_color_identity: cards.courser_of_kruphix.color_identity.color_identities,
  custom_image: cards.courser_of_kruphix.default_image,
  custom_set: cards.courser_of_kruphix.default_set
)

# Sensei's Divining Top
cards.create(
  :senseis_divining_top,
  name: "Sensei's Divining Top",
  cost: "{1}",
  cmc: 1,
  color_identity: ["C"],
  type_line: "Artifact",
  card_text: "{1}: Look at the top three cards of your library, then put them back in any order.\n{T}: Draw a card, then put Sensei's Divining Top on top of its owner's library.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/4/a/4a08ca06-58db-4ce6-b490-be4bea8956a1.jpg?1562759858",
  default_set: "chk",
  scryfall_uri: "https://scryfall.com/card/2x2/314/senseis-divining-top?utm_source=api"
)
cube_cards.create(
  :senseis_divining_top,
  card: cards.senseis_divining_top,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.senseis_divining_top.cmc,
  custom_color_identity: cards.senseis_divining_top.color_identity.color_identities,
  custom_image: cards.senseis_divining_top.default_image,
  custom_set: cards.senseis_divining_top.default_set
)

# Iron Spider, Stark Upgrade
cards.create(
  :iron_spider_stark_upgrade,
  name: "Iron Spider, Stark Upgrade",
  cost: "{3}",
  cmc: 3,
  color_identity: ["C"],
  type_line: "Legendary Artifact Creature — Spider Hero",
  card_text: "Vigilance\n{T}: Put a +1/+1 counter on each artifact creature and/or Vehicle you control.\n{2}, Remove two +1/+1 counters from among artifacts you control: Draw a card.",
  layout: "normal",
  power: 2,
  toughness: 3,
  default_image: "https://cards.scryfall.io/normal/front/8/d/8da5f34e-7f40-406a-88d2-bb1e3ed25200.jpg?1757378035",
  default_set: "spm",
  scryfall_uri: "https://scryfall.com/card/spm/166/iron-spider-stark-upgrade?utm_source=api"
)
cube_cards.create(
  :iron_spider_stark_upgrade,
  card: cards.iron_spider_stark_upgrade,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.iron_spider_stark_upgrade.cmc,
  custom_color_identity: cards.iron_spider_stark_upgrade.color_identity.color_identities,
  custom_image: cards.iron_spider_stark_upgrade.default_image,
  custom_set: cards.iron_spider_stark_upgrade.default_set
)

# Smokestack
cards.create(
  :smokestack,
  name: "Smokestack",
  cost: "{4}",
  cmc: 4,
  color_identity: ["C"],
  type_line: "Artifact",
  card_text: "At the beginning of your upkeep, you may put a soot counter on Smokestack.\nAt the beginning of each player's upkeep, that player sacrifices a permanent for each soot counter on Smokestack.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/6/a/6a37ab2d-094f-431e-878f-93aef0360413.jpg?1562917198",
  default_set: "usg",
  scryfall_uri: "https://scryfall.com/card/vma/282/smokestack?utm_source=api"
)
cube_cards.create(
  :smokestack,
  card: cards.smokestack,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.smokestack.cmc,
  custom_color_identity: cards.smokestack.color_identity.color_identities,
  custom_image: cards.smokestack.default_image,
  custom_set: cards.smokestack.default_set
)

# Skullclamp
cards.create(
  :skullclamp,
  name: "Skullclamp",
  cost: "{1}",
  cmc: 1,
  color_identity: ["C"],
  type_line: "Artifact — Equipment",
  card_text: "Equipped creature gets +1/-1.\nWhenever equipped creature dies, draw two cards.\nEquip {1}",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/5/5/55318397-de3c-47ea-a088-72a24df5c8fa.jpg?1562636939",
  default_set: "dst",
  scryfall_uri: "https://scryfall.com/card/tdc/103/skullclamp?utm_source=api"
)
cube_cards.create(
  :skullclamp,
  card: cards.skullclamp,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.skullclamp.cmc,
  custom_color_identity: cards.skullclamp.color_identity.color_identities,
  custom_image: cards.skullclamp.default_image,
  custom_set: cards.skullclamp.default_set
)

# Stonecoil Serpent
cards.create(
  :stonecoil_serpent,
  name: "Stonecoil Serpent",
  cost: "{X}",
  cmc: 0,
  color_identity: ["C"],
  type_line: "Artifact Creature — Snake",
  card_text: "Reach, trample, protection from multicolored\nStonecoil Serpent enters the battlefield with X +1/+1 counters on it.",
  layout: "normal",
  power: 0,
  toughness: 0,
  default_image: "https://cards.scryfall.io/normal/front/b/3/b34bf7fd-9fe3-43e2-8cfe-7ce7cff08afe.jpg?1572491124",
  default_set: "eld",
  scryfall_uri: "https://scryfall.com/card/cmm/976/stonecoil-serpent?utm_source=api"
)
cube_cards.create(
  :stonecoil_serpent,
  card: cards.stonecoil_serpent,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.stonecoil_serpent.cmc,
  custom_color_identity: cards.stonecoil_serpent.color_identity.color_identities,
  custom_image: cards.stonecoil_serpent.default_image,
  custom_set: cards.stonecoil_serpent.default_set
)

# Ugin, Eye of the Storms
cards.create(
  :ugin_eye_of_the_storms,
  name: "Ugin, Eye of the Storms",
  cost: "{7}",
  cmc: 7,
  color_identity: ["C"],
  type_line: "Legendary Planeswalker — Ugin",
  card_text: "When you cast this spell, exile up to one target permanent that's one or more colors.\nWhenever you cast a colorless spell, exile up to one target permanent that's one or more colors.\n+2: You gain 3 life and draw a card.\n0: Add {C}{C}{C}.\n−11: Search your library for any number of colorless nonland cards, exile them, then shuffle. Until end of turn, you may cast those cards without paying their mana costs.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/6/4/64a5d494-efa1-446b-bebe-2ad36e154376.jpg?1744102946",
  default_set: "tdm",
  scryfall_uri: "https://scryfall.com/card/tdm/1/ugin-eye-of-the-storms?utm_source=api"
)
cube_cards.create(
  :ugin_eye_of_the_storms,
  card: cards.ugin_eye_of_the_storms,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.ugin_eye_of_the_storms.cmc,
  custom_color_identity: cards.ugin_eye_of_the_storms.color_identity.color_identities,
  custom_image: cards.ugin_eye_of_the_storms.default_image,
  custom_set: cards.ugin_eye_of_the_storms.default_set
)

# Chaos Orb
cards.create(
  :chaos_orb,
  name: "Chaos Orb",
  cost: "{2}",
  cmc: 2,
  color_identity: ["C"],
  type_line: "Artifact",
  card_text: "{1}, {T}: If Chaos Orb is on the battlefield, flip Chaos Orb onto the battlefield from a height of at least one foot. If Chaos Orb turns over completely at least once during the flip, destroy all nontoken permanents it touches. Then destroy Chaos Orb.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/9/2/92274971-7c4a-4326-b0fe-75e2d124f718.jpg?1559591491",
  default_set: "lea",
  scryfall_uri: "https://scryfall.com/card/2ed/236/chaos-orb?utm_source=api"
)
cube_cards.create(
  :chaos_orb,
  card: cards.chaos_orb,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.chaos_orb.cmc,
  custom_color_identity: cards.chaos_orb.color_identity.color_identities,
  custom_image: cards.chaos_orb.default_image,
  custom_set: cards.chaos_orb.default_set
)

# Zuran Orb
cards.create(
  :zuran_orb,
  name: "Zuran Orb",
  cost: "{0}",
  cmc: 0,
  color_identity: ["C"],
  type_line: "Artifact",
  card_text: "Sacrifice a land: You gain 2 life.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/3/a/3a9d1082-a862-45d4-9e5e-392e879fead6.jpg?1562905818",
  default_set: "ice",
  scryfall_uri: "https://scryfall.com/card/mh2/300/zuran-orb?utm_source=api"
)
cube_cards.create(
  :zuran_orb,
  card: cards.zuran_orb,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.zuran_orb.cmc,
  custom_color_identity: cards.zuran_orb.color_identity.color_identities,
  custom_image: cards.zuran_orb.default_image,
  custom_set: cards.zuran_orb.default_set
)

# Mox Opal
cards.create(
  :mox_opal,
  name: "Mox Opal",
  cost: "{0}",
  cmc: 0,
  color_identity: ["C"],
  type_line: "Legendary Artifact",
  card_text: "Metalcraft — {T}: Add one mana of any color. Activate only if you control three or more artifacts.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/6/b/6be9b1d5-9ab8-4adb-ba54-2c0117e842fa.jpg?1562818716",
  default_set: "som",
  scryfall_uri: "https://scryfall.com/card/2xm/275/mox-opal?utm_source=api"
)
cube_cards.create(
  :mox_opal,
  card: cards.mox_opal,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.mox_opal.cmc,
  custom_color_identity: cards.mox_opal.color_identity.color_identities,
  custom_image: cards.mox_opal.default_image,
  custom_set: cards.mox_opal.default_set
)

# Chrome Dome
cards.create(
  :chrome_dome,
  name: "Chrome Dome",
  cost: "{2}",
  cmc: 2,
  color_identity: ["C"],
  type_line: "Artifact Creature — Robot Ninja",
  card_text: "Other artifact creatures you control get +1/+0.\n{5}: Create a token that's a copy of another target artifact you control. That token gains haste. Sacrifice it at the beginning of the next end step.",
  layout: "normal",
  power: 1,
  toughness: 3,
  default_image: "https://cards.scryfall.io/normal/front/9/9/994a01eb-2689-49e7-be23-0713da9da9a8.jpg?1769006406",
  default_set: "tmt",
  scryfall_uri: "https://scryfall.com/card/tmt/172/chrome-dome?utm_source=api"
)
cube_cards.create(
  :chrome_dome,
  card: cards.chrome_dome,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.chrome_dome.cmc,
  custom_color_identity: cards.chrome_dome.color_identity.color_identities,
  custom_image: cards.chrome_dome.default_image,
  custom_set: cards.chrome_dome.default_set
)

# City of Traitors
cards.create(
  :city_of_traitors,
  name: "City of Traitors",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "When you play another land, sacrifice City of Traitors.\n{T}: Add {C}{C}.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/a/7/a7a8b6b8-b95f-4014-b17a-a6d44d965995.jpg?1593864142",
  default_set: "exo",
  scryfall_uri: "https://scryfall.com/card/tpr/237/city-of-traitors?utm_source=api"
)
cube_cards.create(
  :city_of_traitors,
  card: cards.city_of_traitors,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.city_of_traitors.cmc,
  custom_color_identity: cards.city_of_traitors.color_identity.color_identities,
  custom_image: cards.city_of_traitors.default_image,
  custom_set: cards.city_of_traitors.default_set
)

# Horizon Canopy
cards.create(
  :horizon_canopy,
  name: "Horizon Canopy",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "{T}, Pay 1 life: Add {G} or {W}.\n{1}, {T}, Sacrifice this land: Draw a card.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/d/5/d5dfc25d-a17b-4ead-9484-e8a18b8fa176.jpg?1562937907",
  default_set: "fut",
  scryfall_uri: "https://scryfall.com/card/fut/177/horizon-canopy?utm_source=api"
)
cube_cards.create(
  :horizon_canopy,
  card: cards.horizon_canopy,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.horizon_canopy.cmc,
  custom_color_identity: cards.horizon_canopy.color_identity.color_identities,
  custom_image: cards.horizon_canopy.default_image,
  custom_set: cards.horizon_canopy.default_set
)

# City of Brass
cards.create(
  :city_of_brass,
  name: "City of Brass",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "Whenever City of Brass becomes tapped, it deals 1 damage to you.\n{T}: Add one mana of any color.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/f/4/f4e32327-380d-471e-813b-4c27477787ce.jpg?1562941005",
  default_set: "arn",
  scryfall_uri: "https://scryfall.com/card/2x2/321/city-of-brass?utm_source=api"
)
cube_cards.create(
  :city_of_brass,
  card: cards.city_of_brass,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.city_of_brass.cmc,
  custom_color_identity: cards.city_of_brass.color_identity.color_identities,
  custom_image: cards.city_of_brass.default_image,
  custom_set: cards.city_of_brass.default_set
)

# Abandoned Air Temple
cards.create(
  :abandoned_air_temple,
  name: "Abandoned Air Temple",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "This land enters tapped unless you control a basic land.\n{T}: Add {W}.\n{3}{W}, {T}: Put a +1/+1 counter on each creature you control.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/9/c/9c0433f9-8f1e-4a19-a83f-a41925f1b1a9.jpg?1764121937",
  default_set: "tla",
  scryfall_uri: "https://scryfall.com/card/tla/263/abandoned-air-temple?utm_source=api"
)
cube_cards.create(
  :abandoned_air_temple,
  card: cards.abandoned_air_temple,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.abandoned_air_temple.cmc,
  custom_color_identity: cards.abandoned_air_temple.color_identity.color_identities,
  custom_image: cards.abandoned_air_temple.default_image,
  custom_set: cards.abandoned_air_temple.default_set
)

# Windbrisk Heights
cards.create(
  :windbrisk_heights,
  name: "Windbrisk Heights",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/9/d/9df6a31a-5c49-4506-b8f8-84c9ab4a2ece.jpg?1562360314",
  default_set: "lrw",
  scryfall_uri: "https://scryfall.com/card/tdc/411/windbrisk-heights?utm_source=api"
)
cube_cards.create(
  :windbrisk_heights,
  card: cards.windbrisk_heights,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.windbrisk_heights.cmc,
  custom_color_identity: cards.windbrisk_heights.color_identity.color_identities,
  custom_image: cards.windbrisk_heights.default_image,
  custom_set: cards.windbrisk_heights.default_set
)

# Evolving Wilds
cards.create(
  :evolving_wilds,
  name: "Evolving Wilds",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "{T}, Sacrifice this land: Search your library for a basic land card, put it onto the battlefield tapped, then shuffle.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/e/b/eb66398d-afb4-41d9-a8b8-ec115d2ad5f2.jpg?1562795079",
  default_set: "dtk",
  scryfall_uri: "https://scryfall.com/card/eoc/158/evolving-wilds?utm_source=api"
)
cube_cards.create(
  :evolving_wilds,
  card: cards.evolving_wilds,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.evolving_wilds.cmc,
  custom_color_identity: cards.evolving_wilds.color_identity.color_identities,
  custom_image: cards.evolving_wilds.default_image,
  custom_set: cards.evolving_wilds.default_set
)

# Rishadan Port
cards.create(
  :rishadan_port,
  name: "Rishadan Port",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "{T}: Add {C}.\n{1}, {T}: Tap target land.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/4/7/477a1f53-5cdf-4b45-b584-2e36b31a3fdb.jpg?1562380426",
  default_set: "mmq",
  scryfall_uri: "https://scryfall.com/card/a25/246/rishadan-port?utm_source=api"
)
cube_cards.create(
  :rishadan_port,
  card: cards.rishadan_port,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.rishadan_port.cmc,
  custom_color_identity: cards.rishadan_port.color_identity.color_identities,
  custom_image: cards.rishadan_port.default_image,
  custom_set: cards.rishadan_port.default_set
)

# Prismatic Vista
cards.create(
  :prismatic_vista,
  name: "Prismatic Vista",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "{T}, Pay 1 life, Sacrifice Prismatic Vista: Search your library for a basic land card, put it onto the battlefield, then shuffle.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/e/3/e37da81e-be12-45a2-9128-376f1ad7b3e8.jpg?1562202585",
  default_set: "mh1",
  scryfall_uri: "https://scryfall.com/card/mh1/244/prismatic-vista?utm_source=api"
)
cube_cards.create(
  :prismatic_vista,
  card: cards.prismatic_vista,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.prismatic_vista.cmc,
  custom_color_identity: cards.prismatic_vista.color_identity.color_identities,
  custom_image: cards.prismatic_vista.default_image,
  custom_set: cards.prismatic_vista.default_set
)

# Simic Growth Chamber
cards.create(
  :simic_growth_chamber,
  name: "Simic Growth Chamber",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "This land enters tapped.\nWhen this land enters, return a land you control to its owner's hand.\n{T}: Add {G}{U}.",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/4/0/407d0a0c-a6be-4bd5-8355-1715698c6bde.jpg?1593274137",
  default_set: "dis",
  scryfall_uri: "https://scryfall.com/card/dis/180/simic-growth-chamber?utm_source=api"
)
cube_cards.create(
  :simic_growth_chamber,
  card: cards.simic_growth_chamber,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.simic_growth_chamber.cmc,
  custom_color_identity: cards.simic_growth_chamber.color_identity.color_identities,
  custom_image: cards.simic_growth_chamber.default_image,
  custom_set: cards.simic_growth_chamber.default_set
)

# Shelldock Isle
cards.create(
  :shelldock_isle,
  name: "Shelldock Isle",
  cost: "",
  cmc: 0,
  color_identity: ["L"],
  type_line: "Land",
  card_text: "",
  layout: "normal",
  power: nil,
  toughness: nil,
  default_image: "https://cards.scryfall.io/normal/front/4/2/4216656e-90e8-45fc-a0f6-0d0d79d0a021.jpg?1562345880",
  default_set: "lrw",
  scryfall_uri: "https://scryfall.com/card/lrw/272/shelldock-isle?utm_source=api"
)
cube_cards.create(
  :shelldock_isle,
  card: cards.shelldock_isle,
  cube: cubes.garfield_cube,
  count: 1,
  custom_cmc: cards.shelldock_isle.cmc,
  custom_color_identity: cards.shelldock_isle.color_identity.color_identities,
  custom_image: cards.shelldock_isle.default_image,
  custom_set: cards.shelldock_isle.default_set
)

