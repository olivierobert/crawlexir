defmodule CrawlexirWeb.SessionControllerTest do
  use CrawlexirWeb.ConnCase
  use Plug.Test

  describe "GET /sessions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))

      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "POST /sessions" do
    test "redirects to the dashboard given valid credentials", %{conn: conn} do
      user = insert(:user, email: "jean@bon.com", password: "12345678")
      sign_in_attributes = %{"email" => "jean@bon.com", "password" => "12345678"}

      conn =
        post(conn, Routes.session_path(conn, :create), sign_in_attributes)

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :success) == "Howdy #{user.first_name}"
    end

    test "renders errors given invalid credentials", %{conn: conn} do
      insert(:user, email: "jean@bon.com", password: "12345678")
      sign_in_attributes = %{"email" => "jean@bon.com", "password" => "invalid"}

      conn =
        post(conn, Routes.session_path(conn, :create), sign_in_attributes)

      assert get_flash(conn, :error) == "The credentials you provided are not correct."
    end
  end

  describe "DELETE /sessions" do
    test "it resets the session and redirect to the sign in page", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> init_test_session(%{})
        |> put_session(:current_user_id, user.id)
        |> put_session(:current_user, user)
        |> delete(Routes.session_path(conn, :delete))

      assert get_session(conn, :current_user_id) == nil
      assert get_session(conn, :current_user) == nil
      assert get_session(conn, :user_signed_in?) == nil
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end
end
