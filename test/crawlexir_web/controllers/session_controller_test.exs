defmodule CrawlexirWeb.SessionControllerTest do
  use CrawlexirWeb.ConnCase

  alias Crawlexir.Auth

  def fixture(:user) do
    user_attributes = %{email: "jean@bon.com", first_name: "Jean", last_name: "Bon", password: "12345678"}
    {:ok, user} = Auth.create_user(user_attributes)
    user
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end


  describe "login a user" do
    test "given valid attributes, it redirects to the dashboard", %{conn: conn} do
      {:ok, user} = create_user()

      conn = post(conn, Routes.session_path(conn, :create), %{"email" => user.email, "password" => user.password})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
      assert get_flash(conn, :success) == "Howdy #{user.first_name}}"
    end

    test "given invalid attributes, it renders errors", %{conn: conn} do
      {:ok, user} = create_user()

      conn = post(conn, Routes.session_path(conn, :create), %{"email" => user.email, "password" => "invalid"})

      assert get_flash(conn, :error) == "The credentials you provided are not correct."
    end
  end

  defp create_user do
    user = fixture(:user)
    {:ok, user}
  end
end
