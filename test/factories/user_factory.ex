defmodule Crawlexir.UserFactory do
  alias Crawlexir.Auth.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: Faker.Internet.safe_email(),
          first_name: Faker.Name.first_name(),
          last_name: Faker.Name.last_name(),
          password: "#{Faker.Lorem.characters(8..15)}"
        }
      end
    end
  end
end
