defmodule Data.Offers.Repo do
  use Ecto.Repo,
    otp_app: :scraper,
    adapter: Ecto.Adapters.Postgres
end
