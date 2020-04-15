defmodule Crawlexir.Google.ResultPage do
  defstruct advertising_content: %{}, organic_content: %{}, page_content: %{}, raw_html: nil

  alias Crawlexir.Google.ResultPage

  @advertiser_selector "li.ads-ad"
  @advertiser_link_selector ".ad_cclk a.V0MxL"
  @organic_link_selector "#search .g .r > a"

  @doc """
  Parse a Google search page and retrieve advertising, organic and general page content.

  ## Example

      iex> new("<html><head>< ...")
      {:ok,
       %ResultPage{
        advertising_content: %{
          count: 1,
          url_list: ["https://some-links.com/"]
        },
        organic_content: %{
          count: 1,
          url_list: ["https://some-links.com/"]
        },
        page_content: %{link_count: 100},
        raw_html:  "<!doctype html><html> <> ..."
      }
  """
  def parse(body) do
    parsed_body = Floki.parse_document!(body)

    {:ok,
     %ResultPage{
       advertising_content: get_advertising_content(parsed_body),
       organic_content: get_organic_content(parsed_body),
       page_content: get_page_content(parsed_body),
       raw_html: cleanup_html(body)
     }}
  end

  defp get_advertising_content(parsed_body) do
    advertiser = parsed_body |> Floki.find(@advertiser_selector)

    advertiser_url_list =
      advertiser
      |> Floki.find(@advertiser_link_selector)
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()

    %{count: length(advertiser), url_list: advertiser_url_list}
  end

  defp get_organic_content(parsed_body) do
    organic_result = parsed_body |> Floki.find(@organic_link_selector)

    organic_result_url_list =
      organic_result
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()

    %{count: length(organic_result), url_list: organic_result_url_list}
  end

  defp get_page_content(parsed_body) do
    links = parsed_body |> Floki.find("a")

    %{link_count: length(links)}
  end

  # Remove any non-UTF8 characters from the HTML body.
  defp cleanup_html(body) do
    body
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end

  defp debug(content) do
    File.write!(Path.expand("./test.html", __DIR__), content)
  end
end
