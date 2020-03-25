defmodule CrawlexirWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Crawlexir.Auth

  def init(default), do: default

  @doc """
  Redirect non-authenticated users to the sign in page
  """
  def call(conn, _) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
        |> put_flash(:info, "Login into your account.")
        |> redirect(to: CrawlexirWeb.Router.Helpers.session_path(conn, :new))
        |> halt()

      user_id ->
        current_user = Auth.get_user!(user_id)

        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)
    end
  end
end