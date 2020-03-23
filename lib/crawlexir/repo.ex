defmodule Crawlexir.Repo do
  use Ecto.Repo,
    otp_app: :crawlexir,
    adapter: Ecto.Adapters.Postgres
end
