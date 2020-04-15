defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.{KeywordScrapingStatusEnum, Report}

  schema "keywords" do
    field :keyword, :string
    field :status, KeywordScrapingStatusEnum, default: :pending

    belongs_to :user, User
    has_one :report, Report

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:keyword, :status, :user_id])
    |> validate_required([:keyword, :user_id])
    |> assoc_constraint(:user)
  end
end
