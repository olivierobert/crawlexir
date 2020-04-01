defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.{Report, ScrapingStatusEnum}

  @required_field ~w(keyword)a
  @optional_field ~w(status)a

  schema "keywords" do
    field :keyword, :string
    field :status, ScrapingStatusEnum, default: :pending

    belongs_to :user, User
    has_one :report, Report

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, @required_field, @optional_field)
    |> validate_required(@required_field)
    |> assoc_constraint(:user)
  end
end
