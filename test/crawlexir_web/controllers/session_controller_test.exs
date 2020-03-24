defmodule CrawlexirWeb.SessionControllerTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  alias Crawlexir.Auth

  def fixture(:user) do
    user_attributes = %{email: "jean@bon.com", first_name: "Jean", last_name: "Bon", password: "12345678"}
    {:ok, user} = Auth.create_user(user_attributes)
    user
  end

  describe "#new" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "#create" do
    setup [:create_user]

    test "given valid attributes, it redirects to the dashboard", %{conn: conn, user: user} do
      conn = post(conn, Routes.session_path(conn, :create), %{"email" => user.email, "password" => user.password})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :success) == "Howdy #{user.first_name}"
    end

    test "given invalid attributes, it renders errors", %{conn: conn, user: user} do
      conn = post(conn, Routes.session_path(conn, :create), %{"email" => user.email, "password" => "invalid"})

      assert get_flash(conn, :error) == "The credentials you provided are not correct."
    end
  end

  describe "#delete" do
    setup [:create_user]

    # FIXME: Revisit to check why the test assertions are failing
    test "it resets the session and redirect to the sign in page", %{conn: conn, user: user} do
      conn = conn
        |> init_test_session(current_user_id: user.id, current_user: user)
        |> delete(Routes.session_path(conn, :delete))

      assert get_session(conn) == %{}
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
