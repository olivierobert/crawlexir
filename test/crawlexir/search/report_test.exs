defmodule Crawlexir.Search.ReportTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Report

  alias Crawlexir.{ReportFactory, KeywordFactory}

  describe "changeset" do
    test "requires the content fields" do
      attributes =
        ReportFactory.build_attributes(
          :report,
          advertiser_link_count: nil,
          advertiser_url_list: nil,
          organic_link_count: nil,
          organic_url_list: nil,
          link_count: nil,
          html_content: nil
        )

      changeset = Report.changeset(%Report{}, attributes)

      refute changeset.valid?
      assert %{advertiser_link_count: ["can't be blank"]} = errors_on(changeset)
      assert %{advertiser_url_list: ["can't be blank"]} = errors_on(changeset)
      assert %{organic_link_count: ["can't be blank"]} = errors_on(changeset)
      assert %{organic_url_list: ["can't be blank"]} = errors_on(changeset)
      assert %{link_count: ["can't be blank"]} = errors_on(changeset)
      assert %{html_content: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires a valid keyword" do
      keyword = KeywordFactory.insert!(:keyword)
      attributes = ReportFactory.build_attributes(:report, keyword: keyword)

      Crawlexir.Repo.delete_all(Crawlexir.Search.Keyword)

      assert {:error, changeset} = ReportFactory.insert!(:report, attributes)
      assert %{keyword: ["does not exist"]} = errors_on(changeset)
    end
  end
end
