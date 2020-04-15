defmodule CrawlexirWeb.SetCurrentUserTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias CrawlexirWeb.Plugs.SetCurrentUser

  describe "init/1" do
    test "returns given options" do
      assert SetCurrentUser.init([]) == []
    end
  end

  describe "call/2" do
    test "assigns current user given an authenticated user" do
      user = insert(:user)

      conn =
        build_conn()
        |> init_test_session(%{current_user_id: user.id})
        |> SetCurrentUser.call(%{})

      assert conn.assigns.current_user == user
      assert conn.assigns.user_signed_in? == true
    end

    test "assigns current user to nil given an unauthenticated user" do
      conn =
        build_conn()
        |> init_test_session(%{current_user_id: nil})
        |> SetCurrentUser.call(%{})

      assert conn.assigns.current_user == nil
      assert conn.assigns.user_signed_in? == false
    end
  end
end
