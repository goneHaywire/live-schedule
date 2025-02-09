defmodule LiveScheduleWeb.GroupLive.Show do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.{User, Group}

  @impl true
  def mount(_params, %{"joined_group" => joined_group} = session, socket) do
    self = self()
    spawn(fn -> :timer.sleep(2000); send(self, :clear_timer) end)

    socket = assign(socket, selected_user: session["selected_user"] || :nil)

    case Ecto.UUID.cast(joined_group) do
      {:ok, _} -> 
        # TODO: handle case where group is not found
        group = Schedules.get_group(joined_group)
        users = Schedules.list_users(group)

        {
          :ok,
          socket
          |> stream(:users, users)
          |> assign(joined_group: joined_group)
          |> assign(:group, group)
          |> assign(:user_count, length(users))
        }
        
      _ -> 
        {
          :ok,
          socket
          # |> redirect(to: ~p"/")
          |> assign(group: %Group{id: "test"})
          |> stream(:users, [])
          |> assign(joined_group: joined_group)
          |> assign(:user_count, 0)
        }
    end
  end

  def handle_info(:clear_timer, socket), do: {:noreply, clear_flash(socket)}
end
