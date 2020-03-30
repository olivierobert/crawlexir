defmodule Crawlexir.Search.ReportTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Report

  describe "validation" do
    test "requires the keyword fields" do
      invalid_attributes = %{
        advertiser_link_count: nil,
        advertiser_url_list: nil,
        organic_link_count: nil,
        organic_url_list: nil,
        link_count: nil,
        html_content: nil
      }
      changeset = Report.changeset(%Report{}, %{keyword: nil})

      refute changeset.valid?
    end
  end
end
