defmodule Crawlexir.Google.ScraperTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Google.Scraper
  alias Crawlexir.Google.ResultPage

  describe "get" do
    test "get/1 with a valid keyword returns a ResultPage" do
      assert {:ok, %ResultPage{} = _result_page} = Scraper.get("project management apps")
    end

    test "get/1 with an HTTP error returns an error" do
      assert {:error, reason} = Scraper.get("keyword error")
    end
  end
end
