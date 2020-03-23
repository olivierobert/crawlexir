defmodule CrawlexirWeb.RegistrationControllerTest do
  use CrawlexirWeb.ConnCase

  alias Crawlexir.Auth

  @create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", password: "some password"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  describe "new registration" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.registration_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "create a new user" do
    test "given valid attributes, it redirects to the dashboard", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)

      conn = get(conn, Routes.dashboard_path(conn, :index))
      assert html_response(conn, 200) =~ "User created successfully."
    end

    test "given invalid attributes, it renders errors", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong! Please check the errors below."
    end
  end
end
