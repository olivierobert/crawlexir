defmodule Crawlexir.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.User

  schema "keywords" do
    field :keyword, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:keyword])
    |> validate_required([:keyword])
  end
end
