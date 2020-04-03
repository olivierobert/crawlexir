defmodule Crawlexir.ReportFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search
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

    build(:report) |> Map.replace!(:keyword_id, keyword.id)
  end

  def insert!(:report, attributes \\ %{}) do
    keyword = attributes[:keyword] || KeywordFactory.insert!(:keyword_with_user)

    case Search.create_keyword_report(keyword, build_attributes(:report, attributes)) do
      {:ok, report} -> report
      {:error, changeset} -> {:error, changeset}
    end
  end
end
