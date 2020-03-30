defmodule Crawlexir.Google.Request do
  @google_base_url "https://www.google.com/search?q="

  def get(keyword, headers) do
    url = @google_base_url <> URI.encode(keyword)

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
