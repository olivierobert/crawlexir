defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.Report

  @required_field ~w(keyword)a

  schema "keywords" do
    field :keyword, :string

    belongs_to :user, User
    has_one :report, Report

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, @required_field)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
  end
end
