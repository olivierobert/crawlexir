defmodule Crawlexir.Search.ReportTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.{Keyword, Report}

  describe "changeset" do
    test "requires the content fields" do
      attributes =
        params_for(:report, %{
          advertiser_link_count: nil,
          advertiser_url_list: nil,
          organic_link_count: nil,
          organic_url_list: nil,
          link_count: nil,
          html_content: nil,
          keyword_id: nil
        })

      changeset = Report.changeset(%Report{}, attributes)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               advertiser_link_count: ["can't be blank"],
               advertiser_url_list: ["can't be blank"],
               organic_link_count: ["can't be blank"],
               organic_url_list: ["can't be blank"],
               link_count: ["can't be blank"],
               html_content: ["can't be blank"],
               keyword_id: ["can't be blank"]
             }
    end

    test "requires a valid keyword" do
      keyword = insert(:keyword_with_user)
      attributes = params_for(:report, %{keyword_id: keyword.id})

      Repo.delete_all(Keyword)

      assert {:error, changeset} = Report.changeset(%Report{}, attributes) |> Repo.insert()
      assert errors_on(changeset) == %{keyword: ["does not exist"]}
    end
  end
end
