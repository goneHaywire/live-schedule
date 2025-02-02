defmodule LiveScheduleWeb.GroupLive.Schedule do
  use LiveScheduleWeb, :live_view

  def mount(_params, _session, socket) do
    self = self()
    spawn(fn -> :timer.sleep(2000); send(self, :clear_timer) end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Under Construction</h1>

    <.link href={~p"/deselect_user"} method="delete">Change user</.link>
    """
  end

  def handle_info(:clear_timer, socket), do: {:noreply, clear_flash(socket)}
end
