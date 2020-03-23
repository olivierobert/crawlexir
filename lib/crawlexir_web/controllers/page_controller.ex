defmodule CrawlexirWeb.PageController do
  use CrawlexirWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
