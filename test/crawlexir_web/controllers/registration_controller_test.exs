defmodule CrawlexirWeb.RegistrationControllerTest do
  use CrawlexirWeb.ConnCase, async: true

  describe "GET /registrations" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.registration_path(conn, :new))

      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "POST /registrations" do
    test "redirects to the dashboard given valid attributes", %{conn: conn} do
      user_attributes = params_for(:user)

      conn = post(conn, Routes.registration_path(conn, :create), user: user_attributes)

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      conn = get(conn, Routes.dashboard_path(conn, :index))
      assert html_response(conn, 200) =~ "User created successfully."
    end

    test "renders errors given invalid attributes", %{conn: conn} do
      user_attributes = params_for(:user, email: nil)

      conn = post(conn, Routes.registration_path(conn, :create), user: user_attributes)

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end
end
