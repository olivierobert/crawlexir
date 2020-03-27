defmodule Crawlexir.Repo.Migrations.AddObanJobsTable do
  use Ecto.Migration

  def up do
    Oban.Migrations.up()
  end

  # Refer to: https://github.com/sorentwo/oban#installation.
  def down do
    Oban.Migrations.down(version: 1)
  end
end
