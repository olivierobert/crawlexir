defmodule Crawlexir.AuthTest do
  use Crawlexir.DataCase

  alias Crawlexir.Auth

  describe "users" do
    alias Crawlexir.Auth.User

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", password: "some password"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "get_user!/1 returns the registration with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a registration" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end
  end
end
