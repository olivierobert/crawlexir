defmodule Crawlexir.UserFactory do
  alias Crawlexir.Auth.User

  defmacro __using__(_opts) do
    quote do
      alias Crawlexir.Auth.Password

      def user_factory(attrs) do
        password = attrs[:password] || "#{Faker.Lorem.characters(8..15)}"

        user = %User{
          email: Faker.Internet.safe_email(),
          first_name: Faker.Name.first_name(),
          last_name: Faker.Name.last_name(),
          encrypted_password: Password.hash_password(password)
        }

        merge_attributes(user, attrs)
      end

      def user_signup_factory do
        user = %User{
          email: Faker.Internet.safe_email(),
          first_name: Faker.Name.first_name(),
          last_name: Faker.Name.last_name(),
          password: "#{Faker.Lorem.characters(8..15)}"
        }
      end
    end
  end
end
