defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.Report

  schema "keywords" do
    field :keyword, :string

    belongs_to :user, User
    has_one :report, Report

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:keyword])
    |> validate_required([:keyword])
  end
end
