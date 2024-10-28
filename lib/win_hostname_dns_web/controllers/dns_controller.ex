defmodule WinHostnameDnsWeb.DnsController do
  use WinHostnameDnsWeb, :controller

  def show(conn, %{"hostname" => hostname}) do
    addr_result =
      hostname
      |> String.to_charlist()
      |> WinHostnameDns.DnsHelper.get_ip_for_hostname()

    case addr_result do
      {:ok, addr} ->
        json(conn, %{success: true, addr: WinHostnameDns.DnsHelper.addr_to_string(addr)})

      {:error, err} ->
        json(conn, %{success: false, error: err})
    end
  end
end
