defmodule CrawlexirWeb.UploadControllerTest do
  use CrawlexirWeb.ConnCase
  use CrawlexirWeb.ControllerCase

  describe "#new" do
    test "renders form", %{conn: conn} do
      conn =
        authenticated_conn()
        |> get(Routes.upload_path(conn, :new))

      assert html_response(conn, 200) =~ "Csv file"
    end
  end

  describe "#create" do
    test "given a valid file, it redirects to the dashboard", %{conn: conn} do
      csv_upload = %Plug.Upload{path: "test/fixtures/assets/keywords.csv", filename: "keywords.csv"}
      conn =
        authenticated_conn()
        |> post(Routes.upload_path(conn, :create), %{"upload" => %{"csv_file" => csv_upload}})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :info) =~ "File uploaded successfully"
    end
  end
end
