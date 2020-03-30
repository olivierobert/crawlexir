defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.KeywordFactory

  alias Crawlexir.Search.Keyword

  describe "validation" do
    test "requires the keyword field" do
      attributes = KeywordFactory.build_attributes(:keyword, keyword: nil)

      changeset = Keyword.changeset(%Keyword{}, attributes)

      refute changeset.valid?
    end
  end
end
