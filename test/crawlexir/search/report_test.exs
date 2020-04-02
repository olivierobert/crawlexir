defmodule Crawlexir.Search.ReportTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Report

  alias Crawlexir.ReportFactory

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
      non_existing_id = 1

      assert_raise Ecto.ConstraintError, fn ->
        ReportFactory.insert!(:report, keyword_id: non_existing_id)
      end
    end
  end
end
