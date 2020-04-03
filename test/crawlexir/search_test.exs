defmodule Crawlexir.SearchTest do
  use Crawlexir.DataCase, async: true
  use Oban.Testing, repo: Crawlexir.Repo

  alias Crawlexir.Search
  alias Crawlexir.Search.{Keyword, Report, ScraperWorker}

  alias Crawlexir.KeywordFactory
  alias Crawlexir.ReportFactory
  alias Crawlexir.UserFactory

  describe "search" do
    test "list_keywords/0 returns all keywords" do
      keyword = KeywordFactory.insert!(:keyword_with_user)

      assert Search.list_keywords() == [keyword]
    end

    test "get_keyword/1 returns the keyword with given id" do
      keyword = KeywordFactory.insert!(:keyword_with_user)

      assert Search.get_keyword(keyword.id) == keyword
    end

    test "get_keyword/1 with invalid data returns nil" do
      non_existing_id = 1

      assert Search.get_keyword(non_existing_id) == nil
    end

    test "create_keyword/1 with valid data creates a keyword" do
      user = UserFactory.insert!(:user)
      keyword_attributes = KeywordFactory.build_attributes(:keyword, keyword: "amazing job")

      assert {:ok, %Keyword{} = keyword} = Search.create_keyword(user, keyword_attributes)
      assert keyword.keyword == "amazing job"
    end

    test "create_keyword/1 with invalid data returns an error changeset" do
      user = UserFactory.insert!(:user)
      keyword_attributes = KeywordFactory.build_attributes(:keyword, keyword: nil)

      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(user, keyword_attributes)
    end

    test "list_user_keyword/1 with valid data returns the list of keyword given a user ID" do
      user = UserFactory.insert!(:user)
      user_keyword = KeywordFactory.insert!(:keyword, user: user)
      _other_user_keyword = KeywordFactory.insert!(:keyword_with_user)

      assert Search.list_user_keyword(user.id) == [user_keyword]
    end

    test "create_keyword/1 returns nil given a user has no keyword" do
      user = UserFactory.insert!(:user)
      _other_user_keyword = KeywordFactory.insert!(:keyword_with_user)

      assert Search.list_user_keyword(user.id) == []
    end

    test "search_for_keyword/1 with valid data creates a keyword" do
      user = UserFactory.insert!(:user)
      keyword_attributes = KeywordFactory.build_attributes(:keyword)

      assert {:ok, %{keyword: keyword, worker: _job}} =
               Search.search_for_keyword(user, keyword_attributes)
    end

    test "update_keyword_status/1 with a valid status returns the updated keyword" do
      keyword = KeywordFactory.insert!(:keyword_with_user, status: :pending)

      assert {:ok, %Keyword{} = updated_keyword} =
               Search.update_keyword_status(keyword, :completed)

      assert updated_keyword.status == :completed
    end

    test "update_keyword_status/1 with an valid status returns an error changeset" do
      keyword = KeywordFactory.insert!(:keyword_with_user, status: :pending)

      assert {:error, %Ecto.Changeset{}} = Search.update_keyword_status(keyword, :invalid)
    end

    test "search_for_keyword/1 with valid data schedule a background job" do
      user = UserFactory.insert!(:user)
      keyword_attributes = KeywordFactory.build_attributes(:keyword)

      assert {:ok, %{keyword: keyword, worker: _job}} =
               Search.search_for_keyword(user, keyword_attributes)

      assert_enqueued(worker: ScraperWorker, args: %{keyword_id: keyword.id})
    end

    test "parse_keyword_file/1 with a valid CSV file returns a list of keyword" do
      valid_file = Path.expand("../fixtures/assets/valid-keyword.csv", __DIR__)

      parsed_result = Search.parse_keyword_file(valid_file)

      assert parsed_result == {:ok, ["first_keyword", "second_keyword"]}
    end

    test "get_report!/1 returns a report with given id" do
      keyword = KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job")
      report = ReportFactory.insert!(:report, keyword_id: keyword.id)

      assert %Report{} = Search.get_report!(report.id)
    end

    test "get_report!/1 with invalid data raises an error" do
      non_existing_id = 1

      assert_raise Ecto.NoResultsError, fn ->
        Search.get_report!(non_existing_id)
      end
    end

    test "get_keyword_report!/1 returns a report with given keyword id" do
      keyword = KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job")
      ReportFactory.insert!(:report, keyword: keyword)

      assert %Report{} = fetched_report = Search.get_keyword_report!(keyword.id)
      assert fetched_report.keyword.keyword == "amazing job"
    end

    test "get_keyword_report!/1 with invalid data raises an error" do
      non_existing_id = 1

      assert_raise Ecto.NoResultsError, fn ->
        Search.get_keyword_report!(non_existing_id)
      end
    end

    test "create_keyword_report/1 with valid data returns a report" do
      keyword = KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job")
      report_attributes = ReportFactory.build_attributes(:report)

      assert {:ok, %Report{} = report} = Search.create_keyword_report(keyword, report_attributes)
      assert report.keyword_id == keyword.id
    end

    test "create_keyword_report/1 with in valid returns an error changeset" do
      keyword = KeywordFactory.insert!(:keyword_with_user, keyword: "amazing job")
      report_attributes = ReportFactory.build_attributes(:report, link_count: nil)

      assert {:error, %Ecto.Changeset{}} =
               Search.create_keyword_report(keyword, report_attributes)
    end
  end
end
