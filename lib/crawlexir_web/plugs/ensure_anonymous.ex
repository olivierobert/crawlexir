defmodule CrawlexirWeb.Plugs.EnsureAnonymous do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  @doc """
  Prevent authenticated users to access auth pages
  """
  def call(conn, _opts) do
    conn |> ensure_anonymous(conn.assigns.user_signed_in?)
  end

  defp ensure_anonymous(conn, true) do
    conn
    |> redirect(to: CrawlexirWeb.Router.Helpers.dashboard_path(conn, :index))
    |> halt()
  end

  defp ensure_anonymous(conn, false), do: conn
end
