defmodule LiveScheduleWeb.GroupLive.Index do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.Group

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :group, %Group{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end
end
