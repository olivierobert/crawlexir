defmodule CrawlexirWeb.Router do
  use CrawlexirWeb, :router

  alias CrawlexirWeb.Plugs.{EnsureAnonymous, EnsureAuthentication, SetCurrentUser}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrawlexirWeb do
    pipe_through [:browser, EnsureAnonymous]

    resources "/registrations", RegistrationController,
      only: [:new, :create],
      singleton: true

    resources "/sessions", SessionController,
      only: [:new, :create],
      singleton: true
  end

  scope "/", CrawlexirWeb do
    pipe_through [:browser, EnsureAuthentication]

    resources "/sessions", SessionController,
      only: [:delete],
      singleton: true

    resources "/uploads", UploadController,
      only: [:new, :create],
      singleton: true

    get "/", DashboardController, :index

    resources "/keywords", KeywordController, only: [:show]
    resources "/reports", ReportController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrawlexirWeb do
  #   pipe_through :api
  # end
end
