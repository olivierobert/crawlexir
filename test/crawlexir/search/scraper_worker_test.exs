defmodule Crawlexir.Search.ScraperWorkerTest do
  use Crawlexir.DataCase, async: true
  use Oban.Testing, repo: Crawlexir.Repo

  alias Crawlexir.Search
  alias Crawlexir.Search.ScraperWorker

  describe "perform" do
    test "perform/1 creates a report" do
      keyword = insert(:keyword_with_user)
      job_attributes = %{keyword_id: keyword.id}

      ScraperWorker.new(job_attributes) |> Oban.insert()

      assert %{success: 1, failure: 0} == Oban.drain_queue(:default)
      assert %Search.Report{} = Search.get_keyword_report!(keyword.id)
    end

    test "perform/1 update the keyword upon success" do
      keyword = insert(:keyword_with_user)
      job_attributes = %{keyword_id: keyword.id}

      ScraperWorker.new(job_attributes) |> Oban.insert()

      Oban.drain_queue(:default)

      # Need to fetch the updated keyword
      assert Search.get_keyword(keyword.id).status == :completed
    end

    test "perform/1 returns an error upon scraping error" do
      keyword = insert(:keyword_with_user, %{keyword: "keyword error"})
      job_attributes = %{keyword_id: keyword.id}

      ScraperWorker.new(job_attributes) |> Oban.insert()

      assert %{success: 0, failure: 1} == Oban.drain_queue(:default)
    end

    test "perform/1 update the keyword upon failure" do
      keyword = insert(:keyword_with_user, %{keyword: "keyword error"})
      job_attributes = %{keyword_id: keyword.id}

      ScraperWorker.new(job_attributes) |> Oban.insert()

      Oban.drain_queue(:default)

      # Need to fetch the updated keyword
      assert Search.get_keyword(keyword.id).status == :failed
    end
  end
end
