defmodule Crawlexir.ReportFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search.Report
  alias Crawlexir.KeywordFactory

  def build(:report) do
    %Report{
      advertiser_link_count: 1,
      advertiser_url_list: ["https://www.google.com"],
      organic_link_count: 1,
      organic_url_list: ["https://www.google.com"],
      link_count: 10,
      html_content: "<html></html>"
    }
  end

  def build(:report_with_keyword) do
    keyword = KeywordFactory.insert!(:keyword)

    build(:report) |> Map.put_new(keyword_id: keyword.id)
  end
end
