defmodule Crawlexir.Search.CsvTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Csv

  describe "csv" do
    test "parse/1 returns the list of keyword given a valid CSV file" do
      valid_file = Path.expand("../../fixtures/assets/valid-keyword.csv", __DIR__)

      parsed_result = Csv.parse(valid_file)

      assert parsed_result == {:ok, ["first_keyword", "second_keyword"]}
    end

    test "parse/1 returns an error given a CSV file that does NOT follow the template" do
      invalid_csv_file = Path.expand("../../fixtures/assets/invalid-keyword.csv", __DIR__)

      parsed_result = Csv.parse(invalid_csv_file)

      assert parsed_result == {:error, "Invalid CSV format"}
    end

    test "parse/1 returns an error given an invalid file" do
      image_file = Path.expand("../../fixtures/assets/phoenix.png", __DIR__)

      parsed_result = Csv.parse(image_file)

      assert parsed_result == {:error, "File cannot be parsed"}
    end
  end
end
