defmodule Crawlexir.Search.Csv do

  @max_keyword_count 100
  @template_header "keyword"

  @doc """
  Parse keywords list from a CSV file.
  Parsing relies on the provided template stored in ""/static/csv/template.csv"

  ## Examples

      iex> "./assets/static/csv/template.csv"
      iex> |> Path.expand(__DIR__)
      iex> |> Crawlexir.Search.Csv.parse
      {:ok, ["first_keyword", "second_keyword"]}

  """
  def parse(file) do
    case parse_with_headers(file) do
      content_list when length(content_list) > 0 ->
        keyword_list = Enum.map(content_list, fn {k, v} -> v[@template_header] end)

        {:ok, keyword_list}
      [] ->
        {:error, "Invalid CSV format"}
    end
  end

  defp parse_with_headers(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
    |> Enum.take(@max_keyword_count)
  end
end
