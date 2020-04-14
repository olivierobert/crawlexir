defmodule CrawlexirWeb.KeywordControllerTest do
  use CrawlexirWeb.ConnCase, async: true

  describe "GET /keywords/:id" do
    test "renders the keyword report", %{conn: conn} do
      user = insert(:user)
      keyword = insert(:keyword, user: user)
      insert(:report, keyword: keyword)

      conn =
        authenticated_conn(user)
        |> get(Routes.keyword_path(conn, :show, keyword.id))

      assert html_response(conn, 200) =~ "Report for \"#{keyword.keyword}\""
    end
  end
end
