defmodule Crawlexir.Auth.UserTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Auth.User

  describe "changeset" do
    test "requires all fields" do
      changeset = User.changeset(%User{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               email: ["can't be blank"],
               first_name: ["can't be blank"],
               last_name: ["can't be blank"],
               password: ["can't be blank"]
             }
    end

    test "email must be of a valid format" do
      attributes = params_for(:user_signup, email: "jean")

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "password must be of a minimum length" do
      attributes = params_for(:user_signup, password: "short")

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert errors_on(changeset) == %{password: ["should be at least 8 character(s)"]}
    end

    test "email must be unique" do
      insert(:user, %{email: "jean@bon.com"})
      attributes = params_for(:user_signup, email: "jean@bon.com")

      assert {:error, changeset} = User.changeset(%User{}, attributes) |> Repo.insert()

      refute changeset.valid?
      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end

    test "password is encrypted into the field encrypted password" do
      attributes = params_for(:user, password: "encryptme")

      changeset = User.changeset(%User{}, attributes)

      assert get_change(changeset, :encrypted_password) != nil
      refute get_change(changeset, :encrypted_password) == "encryptme"
    end
  end
end
