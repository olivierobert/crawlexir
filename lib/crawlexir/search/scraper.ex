defmodule Crawlexir.Search.Scraper do
  alias Crawlexir.Search
  alias Crawlexir.Search.ResultPage

  @google_base_url "https://www.google.com/search?q="

  @browser_user_agent [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/74.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36 Edg/80.0.361.62"
  ]

  def get(keyword) do
    case get_search_page_content(keyword) do
      {:ok, body} -> ResultPage.new(body)
      {:error, reason} -> IO.inspect(reason)
    end
  end

  defp get_search_page_content(keyword) do
    url = @google_base_url <> URI.encode(keyword)
    headers = ["User-Agent": rotated_user_agent()]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp rotated_user_agent do
    @browser_user_agent |> Enum.shuffle() |> Enum.take(1)
  end
end
