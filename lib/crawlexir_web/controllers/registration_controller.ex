defmodule CrawlexirWeb.RegistrationController do
  use CrawlexirWeb, :controller

  alias Crawlexir.Auth
  alias Crawlexir.Auth.User

  plug :put_layout, "auth.html"

  def new(conn, _params) do
    changeset = Auth.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
