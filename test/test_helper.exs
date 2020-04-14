# ExMachina must be started before ExUnit
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Crawlexir.Repo, :manual)
Faker.start()
