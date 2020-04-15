defmodule Crawlexir.Search.Worker do
  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Crawlexir.Search
  alias Crawlexir.Search.Report
  alias Crawlexir.Google.{ResultPage, Scraper}

  @impl Oban.Worker
  def perform(%{"keyword_id" => keyword_id}, _job) do
    fetch_keyword(keyword_id)
    |> update_keyword_status(:in_progress)
    |> get_scraped_content()
    |> create_report()
  end

  defp fetch_keyword(keyword_id) do
    case Search.get_keyword(keyword_id) do
      nil ->
        {:error, "Not found keyword matching ID: #{keyword_id}}"}

      keyword ->
        keyword
    end
  end

  defp update_keyword_status(keyword, status) do
    {:ok, keyword} = Search.update_keyword_status(keyword, status)

    keyword
  end

  def get_scraped_content(keyword) do
    case Scraper.get(keyword.keyword) do
      {:ok, %ResultPage{} = result_page} ->
        %{keyword: keyword, result_page: result_page}

      {:error, reason} ->
        update_keyword_status(keyword, :failed)

        {:error, "No scraped content for #{keyword.id} due to: #{reason}"}
    end
  end

  defp create_report(%{keyword: keyword, result_page: result_page}) do
    case Search.create_keyword_report(keyword, %{
           advertiser_link_count: result_page.advertising_content.count,
           advertiser_url_list: result_page.advertising_content.url_list,
           organic_link_count: result_page.organic_content.count,
           organic_url_list: result_page.organic_content.url_list,
           link_count: result_page.page_content.link_count,
           html_content: result_page.raw_html
         }) do
      {:ok, %Report{} = _report} ->
        update_keyword_status(keyword, :completed)

        :ok

      {:error, _} ->
        {:error, "Failed to create the report for #{keyword.id}"}
    end
  end
end
