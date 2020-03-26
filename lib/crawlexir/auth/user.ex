defmodule Crawlexir.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crawlexir.Auth.Password
  alias Crawlexir.Search.Keyword

  @required_field ~w(email first_name last_name password)a

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true

    has_many :keywords, Keyword

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_field)
    |> validate_required(@required_field)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> encrypt_password
  end

  defp encrypt_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    encrypted_password = Password.hash_password(password)
    put_change(changeset, :encrypted_password, encrypted_password)
  end

  defp encrypt_password(changeset), do: changeset
end
