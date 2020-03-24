defmodule CrawlexirWeb.SessionController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Auth
  alias Crawlexir.Auth.User

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    changeset = Auth.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.login_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "Howdy #{user.first_name}}")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "The credentials you provided are not correct.")
        |> render("new.html")
    end
  end
end
