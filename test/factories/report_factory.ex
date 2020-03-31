defmodule Crawlexir.ReportFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search.Report

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
end
