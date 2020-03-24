defmodule CrawlexirWeb.AuthPlugTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias Crawlexir.Auth

  test "given current_user_id is assigned, it passes through" do
    user_attributes = %{email: "jean@bon.com", first_name: "Jean", last_name: "Bon", password: "12345678"}
    {:ok, user} = Auth.create_user(user_attributes)

    conn =
      build_conn()
      |> Plug.Test.init_test_session(current_user_id: user.id)
      |> get("/")

    assert conn.status == 200
  end

  test "given current_user_id is NOT assigned, it redirects a user" do
    conn =
      build_conn()
      |> Plug.Test.init_test_session(current_user_id: nil)
      |> get("/")

    assert redirected_to(conn) == "/sessions/new"
  end
end