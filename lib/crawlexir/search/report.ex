defmodule Crawlexir.Search.Report do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Search.Keyword

  @permitted_field ~w(advertiser_link_count advertiser_url_list organic_link_count organic_url_list link_count html_content)a

  schema "reports" do
    field :advertiser_link_count, :integer
    field :advertiser_url_list, {:array, :string}
    field :html_content, :string
    field :link_count, :integer
    field :organic_link_count, :integer
    field :organic_url_list, {:array, :string}

    belongs_to :keyword, Keyword

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, @permitted_field)
    |> validate_required(@permitted_field)
    |> assoc_constraint(:keyword)
  end
end
