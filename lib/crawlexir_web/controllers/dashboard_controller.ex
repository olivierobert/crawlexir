defmodule CrawlexirWeb.DashboardController do
  use CrawlexirWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
