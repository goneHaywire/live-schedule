defmodule LiveScheduleWeb.GroupLive.Schedule do
  use LiveScheduleWeb, :live_view
  alias LiveSchedule.Schedules

  def mount(_params, %{"joined_group" => group_id}, socket) do
    self = self()
    group = Schedules.get_group(group_id)
    users = Schedules.list_users(group)
    spawn(fn -> :timer.sleep(2000); send(self, :clear_timer) end)

    {
      :ok,
      socket
      |> assign(:group, group)
      |> assign(:users, Enum.filter(users, & &1.id != socket.assigns.selected_user))
      |> assign(:dates, [])
    }
  end

  def handle_info(:clear_timer, socket), do: {:noreply, clear_flash(socket)}
end
