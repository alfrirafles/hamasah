defmodule OdojWeb.ListLive do
  use OdojWeb, :live_view

  alias Odoj.Users
  alias Odoj.Timer

  def mount(_params, session, socket) do
    member = Users.get_member_by_session_token(session["member_token"])
    {
      :ok,
      assign(socket,
      member: member,
      list_log: list_log(:today),
      mode: "today",
      session_id: session["live_socket_id"]),
      temporary_assigns: [
        list_log: nil
      ]
    }
  end

  def handle_event("filter-all", _params, socket) do
    {:noreply, assign(socket, list_log: list_log(:all), mode: "all")}
  end

  def handle_event("filter-today", _params, socket) do
    {:noreply, assign(socket, list_log: list_log(:today), mode: "today")}
  end

  def handle_event("filter-me", %{"member_id" => id}, socket) do
    member = Users.get_member!(id)
             |> Users.preload_logs()
    unless member.logs == [] do
      {:noreply, assign(socket,
        member: member, list_log: member.logs, mode: "only-me")}
    else
      {:noreply, assign(socket,
        list_log: nil, mode: "only-me")}
    end
  end

  defp list_log(:all) do
    Users.list_log_by_date
  end

  defp list_log(:today) do
    Users.list_log_by_date
      |> Enum.take_while(fn map -> map.date.day == Timer.current_day end)
  end

end