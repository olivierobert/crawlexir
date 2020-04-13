defmodule Crawlexir.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias Crawlexir.Repo

  alias Crawlexir.Search.Csv
  alias Crawlexir.Search.Keyword
  alias Crawlexir.Search.Report
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

  Returns nil if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123)
      %Keyword{}

      iex> get_keyword!(456)
      nil

  """
  def get_keyword(id), do: Repo.get(Keyword, id)

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%User{}, %{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword((%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(%User{} = user, attrs \\ %{}) do
    Ecto.build_assoc(user, :keywords)
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update the scraping status of a keyword.

  ## Examples

      iex> update_keyword_status(%Keyword{}, :completed)
      {:ok, %Keyword{}}

      iex> update_keyword_status((%Keyword{}, :bad_status)
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword_status(%Keyword{} = keyword, status) do
    keyword
    |> Keyword.changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  List all user keywords.

  ## Examples

      iex> list_user_keyword(123)
      [%Keyword{}]

      iex> list_user_keyword(456)
      []
  """
  def list_user_keyword(user_id) do
    Keyword
    |> where(user_id: ^user_id)
    |> Repo.all()
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
      create_scrap_worker_job(keyword.id)
    end)
    |> Repo.transaction()
  end

  defp create_scrap_worker_job(keyword_id) do
    %{keyword_id: keyword_id}
    |> ScraperWorker.new()
    |> Oban.insert()
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

  @doc """
  Gets a single report

  Raises `Ecto.NoResultsError` if the report does not exist.

  ## Examples

      iex> get_report!(report_id)
      {:ok, %Report{}}

      iex> get_report!(report_id)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id), do: Repo.get!(Report, id)

  @doc """
  Gets a single report by keyword ID.

  Raises `Ecto.NoResultsError` if the report does not exist.

  ## Examples

      iex> get_keyword_report!(keyword_id)
      {:ok, %Report{}}

      iex> get_keyword_report!(keyword_id)
      ** (Ecto.NoResultsError)

  """
  def get_keyword_report!(keyword_id) do
    Report
    |> where(keyword_id: ^keyword_id)
    |> preload(:keyword)
    |> Repo.one!()
  end

  @doc """
  Creates a scrapping report for a keyword.

  ## Examples

      iex> create_keyword_report(%Keyword{}, %{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword((%Keyword{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword_report(%Keyword{} = keyword, attrs \\ %{}) do
    Ecto.build_assoc(keyword, :report)
    |> Report.changeset(attrs)
    |> Repo.insert()
  end
end
