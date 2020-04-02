defmodule CrawlexirWeb.KeywordController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Search

  def show(conn, %{"id" => keyword_id}) do
    keyword_report = Search.get_keyword_report(keyword_id)

    render(conn, "show.html", keyword_report: keyword_report)
  end
end
