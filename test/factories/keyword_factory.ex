defmodule Crawlexir.KeywordFactory do
  alias Crawlexir.Search.Keyword

  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %Keyword{
          keyword: Faker.Lorem.word()
        }
      end

      def keyword_with_user_factory do
        %Keyword{
          keyword: Faker.Lorem.word(),
          user: build(:user)
        }
      end
    end
  end
end
