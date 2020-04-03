defmodule Crawlexir.KeywordFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search
  alias Crawlexir.Search.Keyword

  alias Crawlexir.UserFactory

  def build(:keyword) do
    %Keyword{
      keyword: Faker.Lorem.word()
    }
  end

  def build(:keyword_with_user) do
    user = UserFactory.insert!(:user)

    build(:keyword) |> Map.replace!(:user_id, user.id)
  end

  def insert!(:keyword, attributes \\ %{}) do
    user = attributes[:user] || UserFactory.insert!(:user)

    case Search.create_keyword(user, build_attributes(:keyword, attributes)) do
      {:ok, keyword} -> keyword
      {:error, changeset} -> {:error, changeset}
    end
  end

  def insert!(:keyword_with_user, attributes) do
    user = UserFactory.insert!(:user)
    {:ok, keyword} = Search.create_keyword(user, build_attributes(:keyword, attributes))
    keyword
  end
end
