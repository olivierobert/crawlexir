defmodule CrawlexirWeb.EnsureAuthenticationTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias CrawlexirWeb.Plugs.EnsureAuthentication
  alias CrawlexirWeb.Router.Helpers, as: Routes

  describe "init/1" do
    test "returns given options" do
      assert EnsureAuthentication.init([]) == []
    end
  end

  describe "call/2" do
    test "passes through given an authenticated user", %{conn: conn} do
      conn =
        conn
        |> assign(:user_signed_in?, true)
        |> EnsureAuthentication.call(%{})

      refute conn.halted
    end

    test "redirects given an unauthenticated user", %{conn: conn} do
      conn =
        conn
        |> init_test_session(current_user_id: nil)
        |> assign(:user_signed_in?, false)
        |> fetch_flash()
        |> EnsureAuthentication.call(%{})

      assert conn.halted
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      assert get_flash(conn, :info) == "You must be logged in to access this page."
    end
  end
end
