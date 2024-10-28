defmodule WinHostnameDns.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    dns_settings = Application.get_env(:win_hostname_dns, WinHostnameDns.DnsServer)

    children = [
      # Start the Telemetry supervisor
      WinHostnameDnsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WinHostnameDns.PubSub},
      # Start the Endpoint (http/https)
      WinHostnameDnsWeb.Endpoint,
      # Start server under configured port
      {WinHostnameDns.DnsServer, dns_settings[:port]}
    ]

    :ets.new(:hostname_lookups, [:duplicate_bag, :public, :named_table])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WinHostnameDns.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WinHostnameDnsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
