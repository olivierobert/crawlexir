defmodule Crawlexir.Search.Report do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Search.Keyword

  @required_fields ~w(advertiser_link_count advertiser_url_list search_result_link_count search_result_url_list link_count html_content)a

  schema "reports" do
    field :advertiser_link_count, :integer
    field :advertiser_url_list, {:array, :string}
    field :html_content, :string
    field :link_count, :integer
    field :search_result_link_count, :integer
    field :search_result_url_list, {:array, :string}

    belongs_to :keyword, Keyword

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
