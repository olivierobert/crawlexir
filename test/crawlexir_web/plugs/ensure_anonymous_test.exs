defmodule CrawlexirWeb.EnsureAnonymousTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias CrawlexirWeb.Plugs.EnsureAnonymous
  alias CrawlexirWeb.Router.Helpers, as: Routes

  describe "init/1" do
    test "returns given options" do
      assert EnsureAnonymous.init([]) == []
    end
  end

  describe "call/2" do
    test "redirects a user given an authenticated user", %{conn: conn} do
      conn =
        conn
        |> assign(:user_signed_in?, true)
        |> EnsureAnonymous.call(%{})

      assert conn.halted
      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end

    test "it passes through given an unauthenticated user", %{conn: conn} do
      conn =
        conn
        |> assign(:user_signed_in?, false)
        |> EnsureAnonymous.call(%{})

      refute conn.halted
    end
  end
end
