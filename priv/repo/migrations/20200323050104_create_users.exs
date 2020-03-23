defmodule Crawlexir.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :citext
      add :encrypted_password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table(:users)

    execute "DROP EXTENSION citext"
  end
end
