defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase

  alias Crawlexir.Search.Keyword

  describe "validation" do
    test "requires the keyword field" do
      changeset = Keyword.changeset(%Keyword{}, %{keyword: nil})

      refute changeset.valid?
    end
  end
end
