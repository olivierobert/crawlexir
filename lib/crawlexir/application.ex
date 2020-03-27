defmodule Crawlexir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Crawlexir.Repo,
      # Start the endpoint when the application starts
      CrawlexirWeb.Endpoint,
      # Starts a worker by calling: Crawlexir.Worker.start_link(arg)
      # {Crawlexir.Worker, arg},
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crawlexir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CrawlexirWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    opts = Application.get_env(:crawlexir, Oban)

    # Prevent running queues or scheduling jobs from an iex console.
    if Code.ensure_loaded?(IEx) and IEx.started?() do
      opts
      |> Keyword.put(:crontab, false)
      |> Keyword.put(:queues, false)
    else
      opts
    end
  end
end
