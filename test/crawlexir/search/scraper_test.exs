defmodule Crawlexir.Search.ScraperTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Scraper
  alias Crawlexir.Search.ResultPage

  describe "get" do
    test "get/1 with a valid keyword returns a ResultPage" do
      assert {:ok, %ResultPage{} = _result_page} = Scraper.get("project management apps")
    end

    test "get/1 with an HTTP error returns an error" do
      assert {:error, reason} = Scraper.get("error")
    end
  end
end
