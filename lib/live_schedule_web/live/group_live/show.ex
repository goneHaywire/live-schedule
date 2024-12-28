defmodule LiveScheduleWeb.GroupLive.Show do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:group, Schedules.get_group(id))}
  end
end
