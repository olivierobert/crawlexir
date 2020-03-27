defmodule Crawlexir.Search.ScraperWorker do
  use Oban.Worker, queue: :default

  alias Crawlexir.Search
  alias Crawlexir.Search.Scraper
  alias Crawlexir.Search.ResultPage

  @impl Oban.Worker
  def perform(%{"id" => keyword_id} = args, _job) do
    {:ok, keyword} = Search.get_keyword!(keyword_id)
    {:ok, %ResultPage{} = result_page} = Scraper.get(keyword.text)
    {:ok, _} = persist_report(keyword, result_page)
  end

  defp persist_report(keyword, result_page) do
    Search.create_keyword_report(keyword, %{
      advertiser_link_count: result_page.advertising_content.count,
      advertiser_url_list: result_page.advertising_content.url_list,
      search_result_link_count: result_page.organic_content.count,
      search_result_url_list: result_page.organic_content.url_list,
      link_count: result_page.page_content.link_count,
      html_content: result_page.raw_html
    })
  end
end
