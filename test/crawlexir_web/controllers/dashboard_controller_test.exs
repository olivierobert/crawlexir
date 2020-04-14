defmodule CrawlexirWeb.DashboardControllerTest do
  use CrawlexirWeb.ConnCase, async: true

  describe "GET /" do
    test "lists all user keywords", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user_id: user.id)

      conn =
        conn
        |> assign_user(user)
        |> get(Routes.dashboard_path(conn, :index))

      assert html_response(conn, 200) =~ "Dashboard"
      assert conn.assigns.keywords == [keyword]
    end
  end
end
