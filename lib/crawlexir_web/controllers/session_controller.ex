defmodule CrawlexirWeb.SessionController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Auth

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.login_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Howdy #{user.first_name}}")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "The credentials you provided are not correct.")
        |> render("new.html")
    end
  end
end
