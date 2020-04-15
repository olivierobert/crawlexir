defmodule Crawlexir.Repo.Migrations.AddStatusToKeyword do
  use Ecto.Migration

  def change do
    alter table("keywords") do
      add :status, :integer, default: 0
    end
  end
end
