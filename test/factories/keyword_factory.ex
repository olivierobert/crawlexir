defmodule Crawlexir.KeywordFactory do
  use Crawlexir.FactoryBase

  alias Crawlexir.Search.Keyword
  alias Crawlexir.UserFactory

  def build(:keyword) do
    %Keyword{
      keyword: "some keyword"
    }
  end

  def build(:keyword_with_user) do
    user = UserFactory.insert!(:user)

    %Keyword{
      keyword: "some keyword",
      user_id: user.id
    }
  end
end
