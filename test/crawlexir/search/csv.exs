defmodule Crawlexir.Search.CsvTest do
  use Crawlexir.DataCase

  alias Crawlexir.Search.Csv

  describe "csv" do
    test "parse/1 returns the list of keyword given a valid file" do
      valid_file = Path.expand("../../fixtures/assets/valid-keyword.csv", __DIR__)

      parsed_result = Csv.parse(valid_file)

      assert parsed_result == {:ok, ["first_keyword", "second_keyword"]}
    end

    test "parse/1 returns an error given an invalid file" do
      invalid_file = Path.expand("../../fixtures/assets/invalid-keyword.csv", __DIR__)

      parsed_result = Csv.parse(invalid_file)

      assert parsed_result == {:error, "Invalid CSV format"}
    end
  end
end
