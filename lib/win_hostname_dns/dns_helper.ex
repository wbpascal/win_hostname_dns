defmodule WinHostnameDns.DnsHelper do
  def get_ip_for_hostname(hostname) do
    case :inet.getaddr(hostname, :inet) do
      {:ok, addr} ->
        :ets.insert(
          :hostname_lookups,
          {:os.system_time(:milli_seconds), %{hostname: hostname, result: addr |> addr_to_string}}
        )

        {:ok, addr}

      {:error, err} ->
        :ets.insert(
          :hostname_lookups,
          {:os.system_time(:milli_seconds), %{hostname: hostname, result: err}}
        )

        {:error, err}
    end
  end

  def addr_to_string({byte1, byte2, byte3, byte4}) do
    "#{byte1}.#{byte2}.#{byte3}.#{byte4}"
  end
end
