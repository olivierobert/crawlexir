defmodule Crawlexir.Google.RequestMock do
  def get("error", _headers) do
    {:error, :nxdomain}
  end

  def get(_any_other_keyword, _headers) do
    {:ok, valid_page_fixture()}
  end

  defp valid_page_fixture do
    {:ok, page_content} =
      Path.expand("../fixtures/assets/google_search_page.html", __DIR__)
      |> File.read()

    page_content
  end
end
