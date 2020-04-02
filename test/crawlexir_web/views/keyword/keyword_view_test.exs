defmodule CrawlexirWeb.KeywordViewTest do
  use CrawlexirWeb.ConnCase, async: true

  import Phoenix.HTML

  alias CrawlexirWeb.KeywordView
  alias Crawlexir.KeywordFactory

  test "keyword_text_or_link/1 returns a link given a completed keyword" do
    keyword =
      KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job", status: :completed)

    text_or_link = KeywordView.keyword_text_or_link(keyword)

    assert safe_to_string(text_or_link) == "<a href=\"#\">#{keyword.keyword}</a>"
  end

  test "keyword_text_or_link/1 returns a link given a non-completed keyword" do
    keyword = KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job", status: :pending)

    text_or_link = KeywordView.keyword_text_or_link(keyword)

    assert text_or_link == keyword.keyword
  end

  test "status_text/1 returns the correct status top display" do
    pending_keyword = KeywordFactory.insert!(:keyword_with_user, status: :pending)
    in_progress_keyword = KeywordFactory.insert!(:keyword_with_user, status: :in_progress)
    completed_keyword = KeywordFactory.insert!(:keyword_with_user, status: :completed)
    failed_keyword = KeywordFactory.insert!(:keyword_with_user, status: :failed)

    assert KeywordView.status_text(pending_keyword) == "Pending"
    assert KeywordView.status_text(in_progress_keyword) == "Processing"
    assert KeywordView.status_text(completed_keyword) == "Ready"
    assert KeywordView.status_text(failed_keyword) == "Error"
  end
end
