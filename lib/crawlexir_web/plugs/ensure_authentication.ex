defmodule CrawlexirWeb.Plugs.EnsureAuthentication do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  @doc """
  Redirect non-authenticated users to the sign in page
  """
  def call(conn, _opts) do
    conn |> ensure_authentication(conn.assigns.user_signed_in?)
  end

  defp ensure_authentication(conn, true), do: conn

  defp ensure_authentication(conn, false) do
    conn
    |> put_flash(:info, "You must be logged in to access this page.")
    |> redirect(to: CrawlexirWeb.Router.Helpers.session_path(conn, :new))
    |> halt()
  end
end
