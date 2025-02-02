defmodule LiveScheduleWeb.GroupLive.Show do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"group_id" => id}, _, socket) do
    group = Schedules.get_group(id)
    users = Schedules.list_users(group)
    {:noreply,
     socket
     |> assign(:group, group)
     |> stream(:users, users)
     |> assign(:user_count, length(users))
     }
  end
end
