defmodule CrawlexirWeb.Plugs.Guest do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  @doc """
  Prevent authenticated users to access auth pages
  """
  def call(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn

      _user_id ->
        conn
        |> redirect(to: CrawlexirWeb.Router.Helpers.dashboard_path(conn, :index))
        |> halt()
    end
  end
end
