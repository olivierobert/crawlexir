defmodule Crawlexir.Google.ScraperTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Google.Scraper
  alias Crawlexir.Google.ResultPage

  describe "scrap/1" do
    test "returns a ResultPage given a valid keyword" do
      assert {:ok, %ResultPage{} = _result_page} = Scraper.scrap("project management apps")
    end

    test "returns an error when an HTTP error occurs" do
      assert {:error, reason} = Scraper.scrap("keyword error")
    end
  end
end
