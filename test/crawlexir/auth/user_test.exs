defmodule Crawlexir.Auth.UserTest do
  use Crawlexir.DataCase, async: true

  alias Crawlexir.Auth
  alias Crawlexir.Auth.User

  @valid_attributes %{
    email: "jean@bon.com",
    first_name: "Jean",
    last_name: "Bon",
    password: "12345678"
  }

  describe "changeset" do
    test "requires all fields" do
      changeset =
        User.changeset(%User{}, %{email: nil, first_name: nil, last_name: nil, password: nil})

      refute changeset.valid?
    end

    test "email must be of a valid format" do
      attributes = %{@valid_attributes | email: "jean"}

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "password must be of a minimum length" do
      attributes = %{@valid_attributes | password: "short"}

      changeset = User.changeset(%User{}, attributes)

      refute changeset.valid?
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "email must be unique" do
      {:ok, existing_user} = Auth.create_user(@valid_attributes)
      new_user_attributes = %{@valid_attributes | email: existing_user.email}

      assert {:error, changeset} = Auth.create_user(new_user_attributes)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "password is encrypted into the field encrypted password" do
      attributes = %{@valid_attributes | password: "encryptme"}

      changeset = User.changeset(%User{}, @valid_attributes)

      assert changeset.changes[:encrypted_password] !== nil
      assert changeset.changes[:encrypted_password] !== "encryptme"
    end
  end
end
