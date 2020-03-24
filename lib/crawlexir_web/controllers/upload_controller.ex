defmodule CrawlexirWeb.UploadController do
  use CrawlexirWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => upload_params}) do
    conn
  end
end
