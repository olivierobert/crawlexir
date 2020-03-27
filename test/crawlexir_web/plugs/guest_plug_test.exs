defmodule CrawlexirWeb.GuestPlugTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias Crawlexir.Auth

  test "given current_user_id is assigned, it redirects a user" do
    user_attributes = %{
      email: "jean@bon.com",
      first_name: "Jean",
      last_name: "Bon",
      password: "12345678"
    }

    {:ok, user} = Auth.create_user(user_attributes)

    conn =
      build_conn()
      |> init_test_session(current_user_id: user.id)
      |> get("/sessions/new")

    assert redirected_to(conn) == "/"
  end

  test "given current_user_id is NOT assigned, it passes through" do
    conn =
      build_conn()
      |> init_test_session(current_user_id: nil)
      |> get("/sessions/new")

    assert conn.status == 200
    assert conn.request_path == "/sessions/new"
  end
end
