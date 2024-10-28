defmodule WinHostnameDnsWeb.DnsDashboard do
  @moduledoc false
  use Phoenix.LiveDashboard.PageBuilder

  @impl true
  def menu_link(_, _) do
    {:ok, "DNS"}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_table
      id="dns-table"
      dom_id="dns-table"
      page={@page}
      title="DNS"
      row_fetcher={&fetch_ets/2}
      row_attrs={&row_attrs/1}
      rows_name="tables"
    >
      <:col field={:timestamp} sortable={:desc} header="Timestamp (UTC)" />
      <:col field={:hostname} header="Requested Hostname" />
      <:col field={:result} text_align="right" header="Result" />
    </.live_table>
    """
  end

  defp fetch_ets(params, _node) do
    %{limit: limit} = params

    parse_ets_table(:ets.match(:hostname_lookups, {:"$1", :"$2"}, limit), params)
  end

  defp parse_ets_table({result, _continuation}, params) do
    %{sort_by: sort_by, sort_dir: sort_dir} = params

    result =
      result
      |> Enum.map(fn [ts, %{hostname: hn, result: res}] ->
        %{timestamp: ts, hostname: hn, result: res}
      end)

    # Sort results
    result =
      case sort_by do
        :timestamp ->
          result |> Enum.sort_by(& &1.timestamp, sort_dir)
      end

    # Make results more readable
    result =
      result
      |> Enum.map(fn %{timestamp: ts} = entry ->
        entry |> Map.put(:timestamp, ts |> DateTime.from_unix!(:millisecond))
      end)

    {result, length(result)}
  end

  defp parse_ets_table(:"$end_of_table", _params) do
    {[], 0}
  end

  defp row_attrs(_table) do
    []
  end
end
