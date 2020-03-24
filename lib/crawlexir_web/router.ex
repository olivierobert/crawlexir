defmodule CrawlexirWeb.Router do
  use CrawlexirWeb, :router

  alias CrawlexirWeb.Plugs;

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrawlexirWeb do
    pipe_through :browser

    resources "/registrations", RegistrationController, only: [:new, :create],
                                                        singleton: true
    resources "/sessions", SessionController, only: [:new, :create],
                                              singleton: true
  end

  scope "/", CrawlexirWeb do
    pipe_through [:browser, Plugs.Auth]

    get "/", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrawlexirWeb do
  #   pipe_through :api
  # end
end
