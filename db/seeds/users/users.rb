users.create(
  :garfield,
  email: "garfield@gmail.com",
  password: "password",
  admin: true,
  username: "Garfield",
  secret_key: "test_secret"
)
users.create(
  :odie,
  email: "odie@gmail.com",
  password: "password",
  admin: false,
  username: "Odie",
  secret_key: "test_secret"
)
users.create(
  :nermal,
  email: "nermal@gmail.com",
  password: "password",
  admin: false,
  username: "Nermal",
  secret_key: "test_secret"
)
users.create(
  :jon,
  email: "jon@gmail.com",
  password: "password",
  admin: false,
  username: "Jon",
  secret_key: "test_secret"
)
users.create(
  :pooky,
  email: "pooky@gmail.com",
  password: "password",
  admin: false,
  username: "Pooky",
  secret_key: "test_secret"
)
users.create(
  :arlene,
  email: "arlene@gmail.com",
  password: "password",
  admin: false,
  username: "Arlene",
  secret_key: "test_secret"
)

# Extra drafters so the active draft has a production-sized participant count
%w[Liz Lyman Binky Irma Herman Lanolin Squeak Vito].each do |name|
  users.create(
    name.downcase.to_sym,
    email: "#{name.downcase}@gmail.com",
    password: "password",
    admin: false,
    username: name,
    secret_key: "test_secret"
  )
end
