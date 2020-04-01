defmodule Crawlexir.UserFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Auth.User

  def build(:user) do
    %User{
      email: Faker.Internet.safe_email(),
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      password: "#{Faker.Lorem.characters(8..15)}"
    }
  end
end
