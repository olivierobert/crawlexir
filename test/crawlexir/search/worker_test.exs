defmodule Crawlexir.Search.WorkerTest do
  use Crawlexir.DataCase, async: true
  use Oban.Testing, repo: Crawlexir.Repo

  alias Crawlexir.Search
  alias Crawlexir.Search.Worker

  describe "perform/2" do
    test "creates a report" do
      keyword = insert(:keyword_with_user)
      job_attributes = %{keyword_id: keyword.id}

      Worker.new(job_attributes) |> Oban.insert()

      assert %{success: 1, failure: 0} == Oban.drain_queue(:default)
      assert %Search.Report{} = Search.get_keyword_report!(keyword.id)
    end

    test "mark the keyword as completed upon success" do
      keyword = insert(:keyword_with_user)
      job_attributes = %{keyword_id: keyword.id}

      Worker.new(job_attributes) |> Oban.insert()

      Oban.drain_queue(:default)

      # Need to fetch the updated keyword
      assert Search.get_keyword(keyword.id).status == :completed
    end

    test "returns an error upon a scraping error" do
      keyword = insert(:keyword_with_user, %{keyword: "keyword error"})
      job_attributes = %{keyword_id: keyword.id}

      Worker.new(job_attributes) |> Oban.insert()

      assert %{success: 0, failure: 1} == Oban.drain_queue(:default)
    end

    test "mark the keyword as completed upon failure" do
      keyword = insert(:keyword_with_user, %{keyword: "keyword error"})
      job_attributes = %{keyword_id: keyword.id}

      Worker.new(job_attributes) |> Oban.insert()

      Oban.drain_queue(:default)

      # Need to fetch the updated keyword
      assert Search.get_keyword(keyword.id).status == :failed
    end
  end
end
