defmodule Crawlexir.Search.ScraperWorkerTest do
  use Crawlexir.DataCase, async: true
  use Oban.Testing, repo: Crawlexir.Repo

  alias Crawlexir.Search.ScraperWorker
  alias Crawlexir.KeywordFactory

  describe "perform" do
    test "perform/1 creates a report" do
      keyword = KeywordFactory.insert!(:keyword_with_user)
      job_attributes = %{keyword_id: keyword.id}

      ScraperWorker.new(job_attributes) |> Oban.insert()

      assert %{success: 1, failure: 0} == Oban.drain_queue(:default)
    end
  end
end
