defmodule Crawlexir.UserFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Auth.User

  def build(:user) do
    %User{
      email: "jean@bon.com",
      first_name: "Jean",
      last_name: "Bon",
      password: "12345678"
    }
  end
end
