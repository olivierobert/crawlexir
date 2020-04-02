defmodule CrawlexirWeb.ReportController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Search

  def show(conn, %{"id" => report_id}) do
    report = Search.get_report!(report_id)

    html(conn, report.html_content)
  end
end
