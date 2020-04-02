defmodule CrawlexirWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CrawlexirWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias CrawlexirWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint CrawlexirWeb.Endpoint

      # TODO: refactor to keep only one method accepting a user
      def authenticated_conn() do
        user_attributes = %{
          email: "jean@bon.com",
          first_name: "Jean",
          last_name: "Bon",
          password: "12345678"
        }

        {:ok, user} = Crawlexir.Auth.create_user(user_attributes)

        build_conn()
        |> Plug.Test.init_test_session(current_user_id: user.id)
      end

      def authenticated_conn(user) do
        build_conn()
        |> Plug.Test.init_test_session(current_user_id: user.id)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Crawlexir.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Crawlexir.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
