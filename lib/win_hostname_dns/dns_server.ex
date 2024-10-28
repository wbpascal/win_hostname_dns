defmodule WinHostnameDns.DnsServer do
  @moduledoc """
  A simple DNS server using
  """
  @behaviour DNS.Server
  use DNS.Server

  require Logger

  def handle(record, _cl) do
    query = hd(record.qdlist)

    response = %{record | anlist: handle_query(query), header: %{record.header | qr: true}}
    response
  end

  defp handle_query(%{type: :a, domain: hostname} = query) do
    case WinHostnameDns.DnsHelper.get_ip_for_hostname(hostname) do
      {:ok, addr} ->
        [
          %DNS.Resource{
            domain: query.domain,
            class: query.class,
            type: query.type,
            # 10 Minutes
            ttl: 600,
            data: addr
          }
        ]

      _ ->
        []
    end
  end

  defp handle_query(_query) do
    []
  end
end
