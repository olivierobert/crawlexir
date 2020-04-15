defmodule Crawlexir.Google.ResultPage do
  defstruct advertiser_link_count: 0,
            advertiser_url_list: [],
            organic_link_count: 0,
            organic_url_list: [],
            link_count: 0,
            html_content: nil

  alias Crawlexir.Google.ResultPage

  @advertiser_selector "li.ads-ad"
  @advertiser_link_selector ".ad_cclk a.V0MxL"
  @organic_link_selector "#search .g .r > a"

  @doc """
  Parse a Google search page and retrieve advertising, organic and general page content.

  ## Example

      iex> parse("<html><head>< ...")
      {:ok,
       %ResultPage{
        advertiser_link_count: 1,
        advertiser_url_list: ["https://some-links.com/"],
        organic_link_count: 1,
        organic_url_list: ["https://some-links.com/"],
        link_count: 100,
        html_content: "<!doctype html><html> <> ..."
      }
  """
  def parse(html) do
    {:ok, parsed_document} = Floki.parse_document(html)

    parse_html_content(%ResultPage{}, html)
    |> parse_advertising_links(parsed_document)
    |> parse_organic_links(parsed_document)
    |> parse_links(parsed_document)
    |> case do
      %ResultPage{} = result_page -> {:ok, result_page}
      _ -> {:error, :parsing_error}
    end
  end

  defp parse_html_content(result_page, html) do
    %{result_page | html_content: cleanup_html(html)}
  end

  defp parse_advertising_links(result_page, parsed_document) do
    advertiser = parsed_document |> Floki.find(@advertiser_selector)

    advertiser_url_list =
      advertiser
      |> Floki.find(@advertiser_link_selector)
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()

    %{
      result_page
      | advertiser_link_count: length(advertiser),
        advertiser_url_list: advertiser_url_list
    }
  end

  defp parse_organic_links(result_page, parsed_document) do
    organic_result = parsed_document |> Floki.find(@organic_link_selector)

    organic_result_url_list =
      organic_result
      |> Enum.map(&Floki.attribute(&1, "href"))
      |> List.flatten()

    %{
      result_page
      | organic_link_count: length(organic_result),
        organic_url_list: organic_result_url_list
    }
  end

  defp parse_links(result_page, parsed_document) do
    links = parsed_document |> Floki.find("a")

    %{result_page | link_count: length(links)}
  end

  # Remove any non-UTF8 characters from the HTML html.
  defp cleanup_html(html) do
    html
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end

  defp debug(content) do
    File.write!(Path.expand("./test.html", __DIR__), content)
  end
end
