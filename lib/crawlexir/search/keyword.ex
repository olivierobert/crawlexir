defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.{Report, ScrapingStatusEnum}

  @permitted_field ~w(keyword status)a
  @required_field ~w(keyword)a

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
    |> cast(attrs, @permitted_field)
    |> assoc_constraint(:user)
    |> validate_required(@required_field)
  end
end
