defmodule Crawlexir.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"


    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :citext
      add :password, :string

      timestamps()
    end

  end
end
