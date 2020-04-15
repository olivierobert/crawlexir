defmodule Crawlexir.Google.ResultPageTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Google.ResultPage

  describe "result page" do
    test "parse/1 with a valid page body returns advertising content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(page_content)
      assert result_page.advertiser_link_count == 1

      assert result_page.advertiser_url_list == [
               "https://try.wrike.com/google-project-management/"
             ]
    end

    test "parse/1 with a valid page body returns organic content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(page_content)
      assert result_page.organic_link_count == 10

      assert List.first(result_page.organic_url_list) ==
               "https://www.lifehack.org/articles/technology/the-best-8-project-management-apps.html"

      assert List.last(result_page.organic_url_list) ==
               "https://www.projectmanager.com/software/mobile"
    end

    test "parse/1 with a valid page body returns page content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(page_content)
      assert result_page.link_count == 105
    end

    test "parse/1 with a valid page body returns the html content" do
      page_content = valid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(page_content)
      assert result_page.html_content == page_content
    end

    test "parse/1 with a non-search page body returns a valid ResultPage" do
      page_content = invalid_page_fixture()

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(page_content)
      assert result_page.advertiser_link_count == 0
      assert result_page.advertiser_url_list == []
      assert result_page.organic_link_count == 0
      assert result_page.organic_url_list == []
      assert result_page.link_count == 106
      assert result_page.html_content == page_content
    end

    test "parse/1 with an invalid body returns a valid ResultPage" do
      invalid_body = "this is not HTML"

      assert {:ok, %ResultPage{} = result_page} = ResultPage.parse(invalid_body)
      assert result_page.advertiser_link_count == 0
      assert result_page.advertiser_url_list == []
      assert result_page.organic_link_count == 0
      assert result_page.organic_url_list == []
      assert result_page.link_count == 0
      assert result_page.html_content == "this is not HTML"
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
