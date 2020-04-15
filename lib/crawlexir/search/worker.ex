defmodule Crawlexir.Search.Worker do
  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Crawlexir.Search
  alias Crawlexir.Google.{ResultPage, Scraper}

  @impl Oban.Worker
  def perform(%{"keyword_id" => keyword_id}, _job) do
    Search.get_keyword(keyword_id)
    |> perform_keyword_scraping()
  end

  defp perform_keyword_scraping(keyword) do
    with {:ok, _} <- update_keyword_status(keyword, :in_progress),
         {:ok, %ResultPage{} = result_page} <- Scraper.scrap(keyword.keyword),
         {:ok, _} = create_report(keyword, result_page) do
      {:ok, _} = update_keyword_status(keyword, :completed)
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
