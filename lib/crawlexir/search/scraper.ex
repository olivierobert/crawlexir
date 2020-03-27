defmodule Crawlexir.Search.Scraper do

  alias Crawlexir.Search

  @google_base_url "https://www.google.com/search"

  @browser_user_agent [
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/74.0"
  ]

  def get(keyword) do
    case get_search_page_content(keyword) do
      {:ok, body} -> scrap_content(body)
      {:error, reason} -> IO.inspect reason
    end
  end

  defp get_search_page_content(keyword) do
    case HTTPoison.get(@google_base_url, [], params: %{q: URI.encode(keyword)}, headers: ["User-Agent": @browser_user_agent |> Enum.shuffle |> Enum.take(1)]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp scrap_content(body) do
    parsed_content = Floki.parse_document!(body)

#    debug(parsed_content |> Floki.find("#main") |> Floki.raw_html)

    IO.inspect Floki.raw_html(parsed_content)

    links = parsed_content |> Floki.find("a")

    adword_advertiser = parsed_content |> Floki.find("li.ads-ad")
    adword_advertiser_url = adword_advertiser |> Floki.find("h3") |> Enum.map(&Floki.text/1)
    adword_advertiser_count = length(adword_advertiser)

    nonadword_search_result = parsed_content |> Floki.find("#search .g .r > a")
    nonadword_url = nonadword_search_result |> Floki.attribute("href")
    nonadword_count = length(nonadword_search_result)

    IO.inspect(length(links))
    IO.inspect(adword_advertiser_count)
    IO.inspect(adword_advertiser_url)
    IO.inspect(nonadword_url)
    IO.inspect(nonadword_count)

#    Search.create_keyword_report(1, {
#
#    })
  end

#  defp debug(content) do
#    file = File.open!(Path.expand('./test.html', __DIR__), [:write, :utf8])
#    IO.write(file, content)
#    File.close(file)
#  end
end
