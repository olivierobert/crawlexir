defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.KeywordFactory
  alias Crawlexir.Search.Keyword

  describe "changeset" do
    test "requires the keyword field" do
      attributes = KeywordFactory.build_attributes(:keyword_with_user, keyword: nil)
      changeset = Keyword.changeset(%Keyword{}, attributes)

      refute changeset.valid?
      assert %{keyword: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires a valid user" do
      no_user_attributes = KeywordFactory.build_attributes(:keyword, user_id: nil)
      no_user_changeset = Keyword.changeset(%Keyword{}, no_user_attributes)
      non_existing_id = 1

      refute no_user_changeset.valid?
      assert %{user_id: ["can't be blank"]} = errors_on(no_user_changeset)

      assert_raise Ecto.ConstraintError, fn ->
        KeywordFactory.insert!(:keyword, user_id: non_existing_id)
      end
    end
  end
end
