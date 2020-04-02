defmodule CrawlexirWeb.DashboardController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Search

  def index(conn, _) do
    user_keyword_list = Search.list_user_keyword(conn.assigns.current_user.id)

    render(conn, "index.html", keywords: user_keyword_list)
  end
end
