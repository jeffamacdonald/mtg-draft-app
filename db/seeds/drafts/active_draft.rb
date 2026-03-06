drafts.create(
  :active_draft,
  name: "Active Draft",
  participants_count: 6,
  rounds: 36,
  cube: cubes.garfield_cube,
  owner: users.garfield,
  transfers_allowed: true,
  status: "active"
)

# CREATE DRAFT PARTICIPANTS
draft_participants.create(
  :active_draft_garfield,
  draft: drafts.active_draft,
  user: users.garfield,
  display_name: users.garfield.username,
  draft_position: 1
)
draft_participants.create(
  :active_draft_odie,
  draft: drafts.active_draft,
  user: users.odie,
  display_name: users.odie.username,
  draft_position: 2
)
draft_participants.create(
  :active_draft_nermal,
  draft: drafts.active_draft,
  user: users.nermal,
  display_name: users.nermal.username,
  draft_position: 3
)
draft_participants.create(
  :active_draft_jon,
  draft: drafts.active_draft,
  user: users.jon,
  display_name: users.jon.username,
  draft_position: 4
)
draft_participants.create(
  :active_draft_pooky,
  draft: drafts.active_draft,
  user: users.pooky,
  display_name: users.pooky.username,
  draft_position: 5
)
draft_participants.create(
  :active_draft_arlene,
  draft: drafts.active_draft,
  user: users.arlene,
  display_name: users.arlene.username,
  draft_position: 6
)

drafts.active_draft.setup_picks!
