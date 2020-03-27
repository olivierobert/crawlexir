defmodule Crawlexir.Search.Csv do
  @max_keyword_count 100
  @template_header "keyword"

  def parse(file) do
    try do
      case parse_with_headers(file) do
        [_ | _] = content_list ->
          keyword_list = Enum.map(content_list, fn item -> item[@template_header] end)
          {:ok, keyword_list}

        [] ->
          {:error, "Invalid CSV format"}
      end
    rescue
      _e -> {:error, "File cannot be parsed"}
    end
  end

  defp parse_with_headers(file) do
    File.stream!(file)
    |> CSV.decode!(headers: true)
    |> Enum.take(@max_keyword_count)
  end
end
