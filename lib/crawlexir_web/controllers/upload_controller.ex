defmodule CrawlexirWeb.UploadController do
  use CrawlexirWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => upload_params}) do
    conn
      |> put_flash(:info, "File uploaded successfully. Keywords are now being processed.")
      |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
