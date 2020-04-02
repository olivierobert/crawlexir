defmodule CrawlexirWeb.KeywordControllerTest do
  use CrawlexirWeb.ConnCase, async: true

  alias Crawlexir.{KeywordFactory, UserFactory, ReportFactory}

  describe "GET /keywords:id" do
    test "renders the keyword report", %{conn: conn} do
      user = UserFactory.insert!(:user)
      keyword = KeywordFactory.insert!(:keyword, user_id: user.id)
      ReportFactory.insert!(:report, keyword_id: keyword.id)

      conn =
        authenticated_conn(user)
        |> get(Routes.keyword_path(conn, :show, keyword.id))

      assert html_response(conn, 200) =~ "Report for \"#{keyword.keyword}\""
    end
  end
end
