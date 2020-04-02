defmodule CrawlexirWeb.DashboardControllerTest do
  use CrawlexirWeb.ConnCase, async: true

  alias Crawlexir.{UserFactory, KeywordFactory}

  describe "GET /" do
    test "lists all use keywords", %{conn: conn} do
      user = UserFactory.insert!(:user)
      keyword = KeywordFactory.insert!(:keyword, user_id: user.id)

      conn =
        authenticated_conn(user)
        |> get(Routes.dashboard_path(conn, :index))

      assert html_response(conn, 200) =~ "Dashboard"
      assert conn.assigns.keywords == [keyword]
    end
  end
end
