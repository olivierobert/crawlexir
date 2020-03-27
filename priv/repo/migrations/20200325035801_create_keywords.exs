defmodule Crawlexir.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :keyword, :string
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create index(:keywords, [:user_id])
  end
end
