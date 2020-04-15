defmodule Crawlexir.Google.Scraper do
  alias Crawlexir.Google.ResultPage

  @browser_user_agent [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/74.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36 Edg/80.0.361.62"
  ]

  @doc """
  Retrieve structured search results from Google.

  ## Examples

      iex> scrap("project management apps")
      {:ok, %ResultPage{}}

      iex> scrap("invalid search")
      {:error, "Search page cannot be scraped (:nxdomain)"}
  """
  def scrap(keyword) do
    headers = ["User-Agent": rotated_user_agent()]

    case request().get(keyword, headers) do
      {:ok, body} ->
        ResultPage.parse(body)

      {:error, reason} ->
        {:error, "Search page cannot be scraped (#{reason})"}
    end
  end

  defp request do
    Application.get_env(:crawlexir, :google_request)
  end

  defp rotated_user_agent do
    @browser_user_agent |> Enum.shuffle() |> Enum.take(1)
  end
end
