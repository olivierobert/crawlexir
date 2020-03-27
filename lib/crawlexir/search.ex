defmodule Crawlexir.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias Crawlexir.Repo

  alias Crawlexir.Search.Csv
  alias Crawlexir.Search.Keyword
  alias Crawlexir.Search.ScraperWorker

  alias Crawlexir.Auth.User

  @doc """
  Returns the list of keywords.

  ## Examples

      iex> list_keywords()
      [%Keyword{}, ...]

  """
  def list_keywords do
    Repo.all(Keyword)
  end

  @doc """
  Gets a single keyword.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123)
      %Keyword{}

      iex> get_keyword!(456)
      ** (Ecto.NoResultsError)

  """
  def get_keyword!(id), do: Repo.get!(Keyword, id)

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%User{}, %{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword((%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(%User{} = user, attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Creates a keyword and schedule a background job to generate scraping results.

  ## Examples

      iex> search_for_keyword(%User{}, %{field: value})
      {:ok, %{keyword: %Keyword{}, worker: %Oban.job{}}

      iex> search_for_keyword((%User{}, %{field: bad_value})
      {:error, :keyword, reason, _}

  """
  def search_for_keyword(%User{} = user, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:keyword, fn _, _ -> create_keyword(user, attrs) end)
    |> Ecto.Multi.run(:worker, fn _, %{keyword: keyword} ->
      scrap_results_for_keyword(keyword.id)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a keyword.

  ## Examples

      iex> update_keyword(keyword, %{field: new_value})
      {:ok, %Keyword{}}

      iex> update_keyword(keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking keyword changes.

  ## Examples

      iex> change_keyword(keyword)
      %Ecto.Changeset{source: %Keyword{}}

  """
  def change_keyword(%Keyword{} = keyword) do
    Keyword.changeset(keyword, %{})
  end

  @doc """
  Parse keywords list from a CSV file.
  Parsing relies on the provided template stored in "/static/csv/template.csv"

  ## Examples

      iex> "./assets/static/csv/template.csv"
      iex> |> Path.expand(__DIR__)
      iex> |> Crawlexir.Search.parse_keyword_file
      {:ok, ["first_keyword", "second_keyword"]}

  """
  def parse_keyword_file(file) do
    Csv.parse(file)
  end

  defp scrap_results_for_keyword(keyword_id) do
    %{id: keyword_id}
    |> ScraperWorker.new()
    |> Oban.insert()
  end
end
