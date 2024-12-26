defmodule LiveScheduleWeb.GroupLive.Index do
  use LiveScheduleWeb, :live_view

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.Group

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :groups, Schedules.list_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group")
    |> assign(:group, Schedules.get_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:group, %Group{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groups")
    |> assign(:group, nil)
  end

  @impl true
  def handle_info({LiveScheduleWeb.GroupLive.FormComponent, {:saved, group}}, socket) do
    {:noreply, stream_insert(socket, :groups, group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group = Schedules.get_group!(id)
    {:ok, _} = Schedules.delete_group(group)

    {:noreply, stream_delete(socket, :groups, group)}
  end
end
