defmodule Crawlexir.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :advertiser_link_count, :integer
      add :advertiser_url_list, {:array, :string}
      add :organic_link_count, :integer
      add :organic_url_list, {:array, :string}
      add :link_count, :integer
      add :html_content, :text
      add :keyword_id, references(:keywords, on_delete: :delete_all)

      timestamps()
    end

    create index(:reports, [:keyword_id])
  end
end
