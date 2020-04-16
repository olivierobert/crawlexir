defmodule Crawlexir.Search.Worker do
  @moduledoc """
  This worker processes the scraping and creation of the scraping report.

  Job errors are stored in the database via Oban with this structure:
    %{
      "at" => "2020-04-15T10:36:29.142501Z",
      "attempt" => 1,
      "error" => "** (ErlangError) Erlang error: :invalid_keyword_id\n (elixir 1.10.2) lib/process.ex:765: Process.info/2\n
    }
  """

  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Crawlexir.Search
  alias Crawlexir.Search.Keyword
  alias Crawlexir.Google.{ResultPage, Scraper}

  @impl Oban.Worker
  def perform(%{"keyword_id" => keyword_id}, _job) do
    keyword_id
    |> Search.get_keyword()
    |> perform_keyword_scraping()
  end

  defp perform_keyword_scraping(%Keyword{} = keyword) do
    with {:ok, _} <- update_keyword_status(keyword, :in_progress),
         {:ok, %ResultPage{} = result_page} <- Scraper.scrap(keyword.keyword),
         {:ok, _} = create_report(keyword, result_page) do
      update_keyword_status(keyword, :completed)

      :ok
    else
      {:error, reason} ->
        update_keyword_status(keyword, :failed)

        {:error, reason}
    end
  end

  defp perform_keyword_scraping(nil), do: {:error, :invalid_keyword_id}

  defp update_keyword_status(keyword, status) do
    Search.update_keyword_status(keyword, status)
  end

  defp create_report(keyword, result_page) do
    Search.create_keyword_report(keyword, %{
      advertiser_link_count: result_page.advertiser_link_count,
      advertiser_url_list: result_page.advertiser_url_list,
      organic_link_count: result_page.organic_link_count,
      organic_url_list: result_page.organic_url_list,
      link_count: result_page.link_count,
      html_content: result_page.html_content
    })
  end
end
