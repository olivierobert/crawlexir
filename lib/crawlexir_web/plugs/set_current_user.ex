defmodule CrawlexirWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias Crawlexir.Auth

  def init(opts), do: opts

  @doc """
  Prevent authenticated users to access auth pages
  """
  def call(conn, _opts) do
    conn
    |> get_session(:current_user_id)
    |> get_user()
    |> assign_user(conn)
  end

  defp get_user(nil), do: nil
  defp get_user(id), do: Auth.get_user!(id)

  def assign_user(user, conn) do
    conn
    |> assign(:current_user, user)
    |> assign(:user_signed_in?, not is_nil(user))
  end
end
