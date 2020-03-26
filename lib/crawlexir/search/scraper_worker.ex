defmodule Crawlexir.Search.ScraperWorker do
  use Oban.Worker, queue: :default

  alias Crawlexir.Search

  @impl Oban.Worker
  def perform(%{"id" => id} = args, _job) do
    keyword = Search.get_keyword!(id)

    :ok
  end
end
