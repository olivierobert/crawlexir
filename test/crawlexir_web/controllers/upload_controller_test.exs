defmodule CrawlexirWeb.UploadControllerTest do
  use CrawlexirWeb.ConnCase

  alias Crawlexir.Search

  describe "GET /uploads" do
    test "renders form", %{conn: conn} do
      conn =
        authenticated_conn()
        |> get(Routes.upload_path(conn, :new))

      assert html_response(conn, 200) =~ "CSV File"
    end
  end

  describe "POST /uploads" do
    test "redirects to the dashboard given a valid file", %{conn: conn} do
      csv_upload = %Plug.Upload{
        path: "test/fixtures/assets/valid-keyword.csv",
        filename: "valid-keyword.csv"
      }

      conn =
        authenticated_conn()
        |> post(Routes.upload_path(conn, :create), %{"upload" => %{"csv_file" => csv_upload}})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :info) =~ "File uploaded successfully"
    end

    test "creates keywords given a valid file", %{conn: conn} do
      csv_upload = %Plug.Upload{
        path: "test/fixtures/assets/valid-keyword.csv",
        filename: "valid-keyword.csv"
      }

      authenticated_conn()
      |> post(Routes.upload_path(conn, :create), %{"upload" => %{"csv_file" => csv_upload}})

      keywords = Search.list_keywords()

      assert length(keywords) == 2
      assert List.first(keywords).keyword == "first_keyword"
      assert List.last(keywords).keyword == "second_keyword"
    end

    test "shows an error given an invalid file", %{conn: conn} do
      csv_upload = %Plug.Upload{
        path: "test/fixtures/assets/invalid-keyword.csv",
        filename: "invalid-keyword.csv"
      }

      conn =
        authenticated_conn()
        |> post(Routes.upload_path(conn, :create), %{"upload" => %{"csv_file" => csv_upload}})

      assert get_flash(conn, :error) =~ "No valid keyword found"
    end

    test "shows an error given no file", %{conn: conn} do
      conn =
        authenticated_conn()
        |> post(Routes.upload_path(conn, :create), %{})

      assert get_flash(conn, :error) =~ "No file was submitted"
    end
  end
end
