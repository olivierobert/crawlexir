defmodule CrawlexirWeb.GuestPlugTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias CrawlexirWeb.Plugs.Guest
  alias CrawlexirWeb.Router.Helpers, as: Routes

  describe "init/1" do
    test "returns given options" do
      assert Guest.init([]) == []
    end
  end

  describe "call/2" do
    test "redirects a user given an authenticated user" do
      user = insert(:user)

      conn =
        build_conn()
        |> init_test_session(current_user_id: user.id)
        |> Guest.call(%{})

      assert conn.halted
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end

    test "it passes through given an unauthenticated user" do
      conn =
        build_conn()
        |> init_test_session(current_user_id: nil)
        |> Guest.call(%{})

      refute conn.halted
    end
  end
end
