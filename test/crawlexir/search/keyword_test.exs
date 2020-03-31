defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.KeywordFactory
  alias Crawlexir.Search.Keyword

  describe "changeset" do
    test "requires the keyword field" do
      attributes = KeywordFactory.build_attributes(:keyword, keyword: nil)
      changeset = Keyword.changeset(%Keyword{}, attributes)

      refute changeset.valid?
      assert %{keyword: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires a valid user" do
      non_existing_id = 1

      assert_raise Ecto.ConstraintError, fn ->
        KeywordFactory.insert!(:keyword, user_id: non_existing_id)
      end
    end
  end
end
