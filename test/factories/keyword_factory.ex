defmodule Crawlexir.KeywordFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search.Keyword
  alias Crawlexir.UserFactory

  def build(:keyword) do
    %Keyword{
      keyword: Faker.Lorem.word()
    }
  end

  def build(:keyword_with_user) do
    user = UserFactory.insert!(:user)

    build(:keyword) |> Map.replace(:user_id, user.id)
  end
end
