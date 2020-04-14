defmodule Crawlexir.AuthTest do
  use Crawlexir.DataCase

  alias Crawlexir.Auth
  alias Crawlexir.Auth.User

  describe "get_user!/1" do
    test "returns the user given a valid id" do
      user = insert(:user, email: "jean@bon.com")

      created_user = Auth.get_user!(user.id)

      assert created_user.email == "jean@bon.com"
    end
  end

  describe "create_user/1" do
    test "creates a new user given valid data" do
      user_attributes =
        params_for(:user, email: "jean@bon.com", first_name: "Jean", last_name: "Bon")

      assert {:ok, %User{} = user} = Auth.create_user(user_attributes)
      assert user.email == "jean@bon.com"
      assert user.first_name == "Jean"
      assert user.last_name == "Bon"
    end

    test "returns error changeset given invalid data" do
      user_attributes = params_for(:user, email: nil)

      assert {:error, %Ecto.Changeset{}} = Auth.create_user(user_attributes)
    end
  end

  describe "login_user/2" do
    test "returns the user given valid user and credentials" do
      insert(:user, email: "jean@bon.com", password: "12345678")

      assert {:ok, %User{}} = Auth.login_user("jean@bon.com", "12345678")
    end

    test "returns an error given an invalid password " do
      insert(:user, email: "jean@bon.com", password: "12345678")

      assert {:error, :unauthorized} = Auth.login_user("jean@bon.com", "invalid")
    end

    test "returns an error for a non-existing user" do
      assert {:error, :unauthorized} = Auth.login_user("unknown@user.com", "invalid")
    end
  end
end
