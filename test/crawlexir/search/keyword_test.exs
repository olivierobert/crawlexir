defmodule Crawlexir.Search.KeywordTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Auth.User
  alias Crawlexir.Search.Keyword

  describe "changeset" do
    test "requires the keyword field" do
      attributes = params_for(:keyword, %{keyword: nil})

      changeset = Keyword.changeset(%Keyword{}, attributes)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               keyword: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end

    test "requires a valid user" do
      user = insert(:user)
      attributes = params_for(:keyword, %{user_id: user.id})

      Repo.delete_all(User)

      assert {:error, changeset} = Keyword.changeset(%Keyword{}, attributes) |> Repo.insert()
      assert errors_on(changeset) == %{user: ["does not exist"]}
    end
  end
end
