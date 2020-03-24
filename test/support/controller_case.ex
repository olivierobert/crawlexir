defmodule CrawlexirWeb.ControllerCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require an authenticated user.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Crawlexir.Auth

      def authenticated_conn() do
        user_attributes = %{email: "jean@bon.com", first_name: "Jean", last_name: "Bon", password: "12345678"}
        {:ok, user} = Auth.create_user(user_attributes)

        build_conn()
          |> Plug.Test.init_test_session(current_user_id: user.id)
      end
    end
  end
end
