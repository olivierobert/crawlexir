defmodule CrawlexirWeb.KeywordView do
  use CrawlexirWeb, :view

  alias Crawlexir.Search.Keyword

  def keyword_text_or_link(%Keyword{status: :completed} = keyword) do
    # TODO: replace with actual keyword report path
    link(keyword.keyword, to: "#")
  end

  def keyword_text_or_link(%Keyword{} = keyword), do: keyword.keyword

  def status_text(%Keyword{status: :pending}), do: "Pending"
  def status_text(%Keyword{status: :in_progress}), do: "Processing"
  def status_text(%Keyword{status: :completed}), do: "Ready"
  def status_text(%Keyword{status: :failed}), do: "Error"

  def status_text(%Keyword{}), do: "N/A"
end
