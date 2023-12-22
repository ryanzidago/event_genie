defmodule EventGenie.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EventGenieWeb.Telemetry,
      EventGenie.Repo,
      {DNSCluster, query: Application.get_env(:event_genie, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EventGenie.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EventGenie.Finch},
      # Start a worker by calling: EventGenie.Worker.start_link(arg)
      # {EventGenie.Worker, arg},
      # Start to serve requests, typically the last entry
      EventGenieWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventGenie.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventGenieWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
