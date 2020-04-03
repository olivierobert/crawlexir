defmodule Crawlexir.Auth.UserTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Auth
  alias Crawlexir.Auth.User

  alias Crawlexir.UserFactory

  describe "changeset" do
    test "requires all fields" do
      changeset =
        User.changeset(%User{}, %{email: nil, first_name: nil, last_name: nil, password: nil})

      refute changeset.valid?
    end

    test "email must be of a valid format" do
      attributes = UserFactory.build_attributes(:user, email: "jean")

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "password must be of a minimum length" do
      attributes = UserFactory.build_attributes(:user, password: "short")

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "email must be unique" do
      UserFactory.insert!(:user, email: "jean@bon.com")
      new_user_attributes = UserFactory.build_attributes(:user, email: "jean@bon.com")

      assert {:error, changeset} = Auth.create_user(new_user_attributes)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "password is encrypted into the field encrypted password" do
      attributes = UserFactory.build_attributes(:user, password: "encryptme")

      changeset = User.changeset(%User{}, attributes)

      assert changeset.changes[:encrypted_password] !== nil
      assert changeset.changes[:encrypted_password] !== "encryptme"
    end
  end
end
