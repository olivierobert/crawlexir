defmodule CrawlexirWeb.AuthPlugTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias CrawlexirWeb.Plugs.Auth
  alias CrawlexirWeb.Router.Helpers, as: Routes

  describe "init/1" do
    test "returns given options" do
      assert Auth.init([]) == []
    end
  end

  describe "call/2" do
    test "passes through given an authenticated user" do
      user = insert(:user)

      conn =
        build_conn()
        |> init_test_session(current_user_id: user.id)
        |> Auth.call(%{})

      refute conn.halted
    end

    test "redirects given an unauthenticated user" do
      conn =
        build_conn()
        |> init_test_session(current_user_id: nil)
        |> fetch_flash()
        |> Auth.call(%{})

      assert conn.halted
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

  end
end
