import Config

config :scraper, Data.Offers.Repo,
  database: "re_offers",
  username: "re_offers",
  password: "abc",
  hostname: "localhost"

config :scraper, ecto_repos: [Data.Offers.Repo]
