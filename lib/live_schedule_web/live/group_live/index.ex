defmodule LiveScheduleWeb.GroupLive.Index do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.Group

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :group, %Group{})}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp form_title(:new), do: "Create Group" 
  defp form_title(:join), do: "Join Group" 

  defp form_subtitle(:new), do: "Enter a new group name" 
  defp form_subtitle(:join), do: "Enter a group id to join" 

  defp form_btn(:new), do: "Create" 
  defp form_btn(:join), do: "Join" 

end
