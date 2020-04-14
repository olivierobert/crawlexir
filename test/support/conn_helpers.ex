defmodule Crawlexir.ConnHelpers do
  alias Plug.Conn

  import Crawlexir.Factory

  def assign_user(%Conn{} = conn, user) do
    conn
    |> Plug.Test.init_test_session(current_user_id: user.id)
  end

  def assign_user(%Conn{} = conn) do
    user = insert(:user)

    conn
    |> Plug.Test.init_test_session(current_user_id: user.id)
  end
end
