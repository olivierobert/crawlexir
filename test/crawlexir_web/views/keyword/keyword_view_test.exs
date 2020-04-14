defmodule CrawlexirWeb.KeywordViewTest do
  use CrawlexirWeb.ConnCase, async: true

  import Phoenix.HTML

  alias CrawlexirWeb.KeywordView

  describe "keyword_text_or_link/2" do
    test "returns a link given a completed keyword", %{conn: conn} do
      keyword = insert(:keyword_with_user, keyword: "amazing job", status: :completed)

      text_or_link = KeywordView.keyword_text_or_link(conn, keyword)

      assert safe_to_string(text_or_link) ==
               "<a href=\"/keywords/#{keyword.id}\">#{keyword.keyword}</a>"
    end

    test "returns a link given a non-completed keyword", %{conn: conn} do
      keyword = insert(:keyword_with_user, keyword: "amazing job", status: :pending)

      text_or_link = KeywordView.keyword_text_or_link(conn, keyword)

      assert text_or_link == keyword.keyword
    end
  end

  describe "status_text/1" do
    test "returns the correct status top display" do
      pending_keyword = insert(:keyword_with_user, status: :pending)
      in_progress_keyword = insert(:keyword_with_user, status: :in_progress)
      completed_keyword = insert(:keyword_with_user, status: :completed)
      failed_keyword = insert(:keyword_with_user, status: :failed)

      assert KeywordView.status_text(pending_keyword) == "Pending"
      assert KeywordView.status_text(in_progress_keyword) == "Processing"
      assert KeywordView.status_text(completed_keyword) == "Ready"
      assert KeywordView.status_text(failed_keyword) == "Error"
    end
  end
end
