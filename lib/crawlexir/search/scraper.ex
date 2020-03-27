defmodule Crawlexir.Search.Scraper do
  alias Crawlexir.Search

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
      {:ok, body} -> scrap_content(body)
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

  defp scrap_content(body) do
    parsed_content = Floki.parse_document!(body)

    debug(body)

    links = parsed_content |> Floki.find("a")

    adword_advertiser = parsed_content |> Floki.find("li.ads-ad")

    adword_advertiser_url =
      adword_advertiser
      |> Floki.find(".ad_cclk a.V0MxL")
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()

    adword_advertiser_count = length(adword_advertiser)

    nonadword_search_result = parsed_content |> Floki.find("#search .g .r > a")

    nonadword_url =
      nonadword_search_result |> Enum.map(&Floki.attribute(&1, "href")) |> List.flatten()

    nonadword_count = length(nonadword_search_result)

    IO.inspect(length(links))
    IO.inspect(adword_advertiser_count)
    IO.inspect(adword_advertiser_url)
    IO.inspect(nonadword_url)
    IO.inspect(nonadword_count)

    Search.create_keyword_report(1, %{
      advertiser_link_count: adword_advertiser_count,
      advertiser_url_list: adword_advertiser_url,
      link_count: length(links),
      search_result_link_count: nonadword_count,
      search_result_url_list: nonadword_url,
      html_content: cleanup_html(body)
    })
  end

  defp rotated_user_agent do
    @browser_user_agent |> Enum.shuffle() |> Enum.take(1)
  end

  @doc """
  Remove any non-UTF1 characters from the HTML body.
  """
  defp cleanup_html(body) do
    body
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end

  defp debug(content) do
    File.write!(Path.expand('./test.html', __DIR__), content)
  end
end
