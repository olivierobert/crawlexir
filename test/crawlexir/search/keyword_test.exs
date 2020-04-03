defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Search.Keyword

  alias Crawlexir.{KeywordFactory, UserFactory}

  describe "changeset" do
    test "requires the keyword field" do
      attributes = KeywordFactory.build_attributes(:keyword, keyword: nil)
      changeset = Keyword.changeset(%Keyword{}, attributes)

      refute changeset.valid?
      assert %{keyword: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires a valid user" do
      user = UserFactory.insert!(:user)
      attributes = KeywordFactory.build_attributes(:keyword, user: user)

      Crawlexir.Repo.delete_all(Crawlexir.Auth.User)

      assert {:error, changeset} = KeywordFactory.insert!(:keyword, attributes)
      assert %{user: ["does not exist"]} = errors_on(changeset)
    end
  end
end
