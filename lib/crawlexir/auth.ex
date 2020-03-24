defmodule Crawlexir.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Crawlexir.Repo

  alias Crawlexir.Auth.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the user does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Register a new user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticate a user with provided credentials.

  ## Examples

      iex> login_user(valid_email, valid_password)
      {:ok, %User{}}

      iex> login_user(valid_email, invalid_password)
      {:error, :unauthorized}

  """
  def login_user(email, password) do
    user_query = from u in User, where: u.email == ^email

    case Repo.one(user_query) do
      %User{} = user -> authenticate_user(user, password)
      nil -> {:error, :unauthorized}
    end
  end

  defp authenticate_user(user, password) do
    case Crawlexir.Auth.Password.validate_password(user, password) do
      {:ok, %User{} = user } -> {:ok, user}
      {:error, "invalid password"} -> {:error, :unauthorized}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(registration)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
