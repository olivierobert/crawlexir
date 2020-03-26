defmodule Crawlexir.SearchTest do
  use Crawlexir.DataCase

  alias Crawlexir.Auth
  alias Crawlexir.Search

  describe "keywords" do
    alias Crawlexir.Search.Keyword

    @valid_attrs %{keyword: "some keyword"}
    @update_attrs %{keyword: "some updated keyword"}
    @invalid_attrs %{keyword: nil}

    def keyword_fixture(attrs \\ %{}) do
      user = user_fixture()
      keyword_attributes = attrs |> Enum.into(@valid_attrs)
      {:ok, keyword} = Search.create_keyword(user, keyword_attributes)

      keyword
    end

    def user_fixture() do
      user_attributes = %{email: "jean@bon.com", first_name: "Jean", last_name: "Bon", password: "12345678"}
      {:ok, user} = Auth.create_user(user_attributes)

      user
    end

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Search.list_keywords() == [keyword]
    end

    test "get_keyword!/1 returns the keyword with given id" do
      keyword = keyword_fixture()
      assert Search.get_keyword!(keyword.id) == keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      user = user_fixture()

      assert {:ok, %Keyword{} = keyword} = Search.create_keyword(user, @valid_attrs)
      assert keyword.keyword == "some keyword"
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(user, @invalid_attrs)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{} = keyword} = Search.update_keyword(keyword, @update_attrs)
      assert keyword.keyword == "some updated keyword"
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = keyword_fixture()
      assert {:error, %Ecto.Changeset{}} = Search.update_keyword(keyword, @invalid_attrs)
      assert keyword == Search.get_keyword!(keyword.id)
    end

    test "change_keyword/1 returns a keyword changeset" do
      keyword = keyword_fixture()
      assert %Ecto.Changeset{} = Search.change_keyword(keyword)
    end

    test "parse_keyword_file/1 with a valid CSV file returns a list of keyword" do
      valid_file = Path.expand("../fixtures/assets/valid-keyword.csv", __DIR__)

      parsed_result = Search.parse_keyword_file(valid_file)

      assert parsed_result == {:ok, ["first_keyword", "second_keyword"]}
    end
  end
end
