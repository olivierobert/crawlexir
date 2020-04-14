defmodule Crawlexir.SearchTest do
  use Crawlexir.DataCase, async: true
  use Oban.Testing, repo: Crawlexir.Repo

  alias Crawlexir.Search
  alias Crawlexir.Search.{Keyword, Report, ScraperWorker}

  describe "list_keywords/0" do
    test "returns all keywords" do
      user = insert(:user)
      keyword = insert(:keyword, user_id: user.id)

      assert Search.list_keywords() == [keyword]
    end
  end

  describe "get_keyword/1" do
    test "returns the keyword with given id" do
      user = insert(:user)
      keyword = insert(:keyword, keyword: "amazing job", user_id: user.id)

      assert Search.get_keyword(keyword.id) == keyword
    end

    test "get_keyword/1 with invalid data returns nil" do
      non_existing_id = 1

      assert Search.get_keyword(non_existing_id) == nil
    end
  end

  describe "create_keyword/2" do
    test "creates a keyword given valid data" do
      user = insert(:user)
      keyword_attributes = params_for(:keyword, keyword: "amazing job")

      assert {:ok, %Keyword{} = created_keyword} = Search.create_keyword(user, keyword_attributes)
      assert created_keyword.keyword == "amazing job"
    end

    test "returns an error changeset given invalid data" do
      user = insert(:user)
      keyword_attributes = params_for(:keyword, %{keyword: nil})

      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(user, keyword_attributes)
    end
  end

  describe "update_keyword_status/2" do
    test "returns the updated keyword given a valid status" do
      keyword = insert(:keyword_with_user, status: :pending)

      assert {:ok, %Keyword{} = updated_keyword} =
               Search.update_keyword_status(keyword, :completed)

      assert updated_keyword.status == :completed
    end

    test "returns an error changeset given an invalid status" do
      keyword = insert(:keyword_with_user, status: :pending)

      assert {:error, %Ecto.Changeset{}} = Search.update_keyword_status(keyword, :invalid)
    end
  end

  describe "list_user_keyword/1" do
    test "returns the list of keyword given a user ID" do
      user = insert(:user)
      user_keyword = insert(:keyword, user_id: user.id)
      _other_user_keyword = insert(:keyword_with_user)

      assert Search.list_user_keyword(user.id) == [user_keyword]
    end

    test "returns nil given a user has no keyword" do
      user = insert(:user)
      _other_user_keyword = insert(:keyword_with_user)

      assert Search.list_user_keyword(user.id) == []
    end
  end

  describe "search_for_keyword/1" do
    test "creates a keyword given valid data" do
      user = insert(:user)
      keyword_attributes = params_for(:keyword)

      assert {:ok, %{keyword: keyword, worker: _job}} =
               Search.search_for_keyword(user, keyword_attributes)
    end

    test "schedules a background job given valid data" do
      user = insert(:user)
      keyword_attributes = params_for(:keyword)

      assert {:ok, %{keyword: keyword, worker: _job}} =
               Search.search_for_keyword(user, keyword_attributes)

      assert_enqueued(worker: ScraperWorker, args: %{keyword_id: keyword.id})
    end
  end

  describe "parse_keyword_file/1" do
    test "returns a list of keyword given a valid CSV file" do
      valid_file = Path.expand("../fixtures/assets/valid-keyword.csv", __DIR__)

      parsed_result = Search.parse_keyword_file(valid_file)

      assert parsed_result == {:ok, ["first_keyword", "second_keyword"]}
    end
  end

  describe "get_report!/1" do
    test "returns a report with given id" do
      keyword = insert(:keyword_with_user, keyword: "amazing job")
      report = insert(:report, keyword: keyword)

      assert %Report{} = Search.get_report!(report.id)
    end

    test "raises an error given invalid data" do
      non_existing_id = 1

      assert_raise Ecto.NoResultsError, fn ->
        Search.get_report!(non_existing_id)
      end
    end
  end

  describe "get_keyword_report!/1" do
    test "returns a report with given keyword id" do
      keyword = insert(:keyword_with_user, keyword: "amazing job")
      insert(:report, keyword: keyword)

      assert %Report{} = fetched_report = Search.get_keyword_report!(keyword.id)
      assert fetched_report.keyword.keyword == "amazing job"
    end

    test "raises an error given invalid data " do
      non_existing_id = 1

      assert_raise Ecto.NoResultsError, fn ->
        Search.get_keyword_report!(non_existing_id)
      end
    end
  end

  describe "create_keyword_report!/2" do
    test "returns a report given valid data" do
      keyword = insert(:keyword_with_user, keyword: "amazing job")
      report_attributes = params_for(:report)

      assert {:ok, %Report{} = report} = Search.create_keyword_report(keyword, report_attributes)
      assert report.keyword_id == keyword.id
    end

    test "returns an error changeset given invalid data" do
      keyword = insert(:keyword_with_user, keyword: "amazing job")
      report_attributes = params_for(:report, link_count: nil)

      assert {:error, %Ecto.Changeset{}} =
               Search.create_keyword_report(keyword, report_attributes)
    end
  end
end
