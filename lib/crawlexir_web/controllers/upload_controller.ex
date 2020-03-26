defmodule CrawlexirWeb.UploadController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Search

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %{ "csv_file" => file }}) do
    case parse_keyword_from(file) do
      {:ok, keyword_list} ->
        keyword_list
        |> Enum.each(fn keyword -> Search.create_keyword(conn.assigns.current_user, %{keyword: keyword}) end)

        conn
        |> put_flash(:info, "File uploaded successfully. Keywords are now being processed.")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "No valid keyword found in the submitted file. Make sure to use the provided template.")
        |> redirect(to: Routes.upload_path(conn, :new))
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "No file was submitted. Select a CSV file to search for keywords.")
    |> redirect(to: Routes.upload_path(conn, :new))
  end

  defp parse_keyword_from(file) do
    file.path |> Search.parse_keyword_file
  end
end
