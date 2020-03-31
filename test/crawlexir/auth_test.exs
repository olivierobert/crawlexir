defmodule Crawlexir.AuthTest do
  use Crawlexir.DataCase

  alias Crawlexir.Auth

  alias Crawlexir.UserFactory

  describe "auth" do
    alias Crawlexir.Auth.User

    test "get_user!/1 returns the user with given id" do
      user = UserFactory.insert!(:user, email: "jean@bon.com")

      created_user = Auth.get_user!(user.id)

      assert created_user.email == "jean@bon.com"
    end

    test "create_user/1 with valid data creates a new user" do
      user_attributes =
        UserFactory.build_attributes(:user,
          email: "jean@bon.com",
          first_name: "Jean",
          last_name: "Bon"
        )

      assert {:ok, %User{} = user} = Auth.create_user(user_attributes)
      assert user.email == "jean@bon.com"
      assert user.first_name == "Jean"
      assert user.last_name == "Bon"
    end

    test "create_user/1 with invalid data returns error changeset" do
      user_attributes = UserFactory.build_attributes(:user, email: nil)

      assert {:error, %Ecto.Changeset{}} = Auth.create_user(user_attributes)
    end

    test "login_user/2 with valid data returns the user" do
      user_attributes =
        UserFactory.build_attributes(:user, email: "jean@bon.com", password: "12345678")

      Auth.create_user(user_attributes)

      assert {:ok, %User{}} = Auth.login_user("jean@bon.com", "12345678")
    end

    test "login_user/2 with invalid password returns an error" do
      user_attributes =
        UserFactory.build_attributes(:user, email: "jean@bon.com", password: "12345678")

      Auth.create_user(user_attributes)

      assert {:error, :unauthorized} = Auth.login_user("jean@bon.com", "invalid")
    end

    test "login_user/2 for a non-existing user returns an error" do
      assert {:error, :unauthorized} = Auth.login_user("unknown@user.com", "invalid")
    end
  end
end
