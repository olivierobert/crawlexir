defmodule Crawlexir.Search.ResultPageTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.ResultPage

  describe "new" do
    test "new/1 with a valid page body returns advertising content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(page_content)
      assert result_page.advertising_content.count == 1

      assert result_page.advertising_content.url_list == [
               "https://try.wrike.com/google-project-management/"
             ]
    end

    test "new/1 with a valid page body returns organic content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(page_content)
      assert result_page.organic_content.count == 10

      assert List.first(result_page.organic_content.url_list) ==
               "https://www.lifehack.org/articles/technology/the-best-8-project-management-apps.html"

      assert List.last(result_page.organic_content.url_list) ==
               "https://www.projectmanager.com/software/mobile"
    end

    test "new/1 with a valid page body returns page content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(page_content)
      assert result_page.page_content.link_count == 105
    end

    test "new/1 with a valid page body returns raw html" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(page_content)
      assert result_page.raw_html == page_content
    end

    test "new/1 with a non-search page body returns a valid ResultPage" do
      page_content = invalid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(page_content)
      assert result_page.advertising_content == %{count: 0, url_list: []}
      assert result_page.organic_content == %{count: 0, url_list: []}
      assert result_page.page_content == %{link_count: 106}
      assert result_page.raw_html == page_content
    end

    test "new/1 with an invalid body returns a valid ResultPage" do
      invalid_body = "this is not HTML"

      assert {:ok, %ResultPage{} = result_page} = ResultPage.new(invalid_body)
      assert result_page.advertising_content == %{count: 0, url_list: []}
      assert result_page.organic_content == %{count: 0, url_list: []}
      assert result_page.page_content == %{link_count: 0}
      assert result_page.raw_html == "this is not HTML"
    end
  end

  defp valid_page_fixture do
    {:ok, page_content} =
      Path.expand("../../fixtures/assets/google_search_page.html", __DIR__)
      |> File.read()

    page_content
  end

  defp invalid_page_fixture do
    {:ok, page_content} =
      Path.expand("../../fixtures/assets/github_page.html", __DIR__)
      |> File.read()

    page_content
  end
end
