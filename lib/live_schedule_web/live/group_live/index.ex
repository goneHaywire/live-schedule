defmodule LiveScheduleWeb.GroupLive.Index do
  use LiveScheduleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid sm:grid-cols-[1fr_3px_1fr] gap-x-10 gap-y-20 justify-items-center items-center h-80 sm:h-40">
      <.link navigate={~p"/new"}>
        <div class="flex items-center w-60 h-40 sm:h-20 justify-center text-4xl sm:text-2xl bg-black rounded-md text-white">New Group</div>
      </.link>
      <div class="hidden sm:block rounded-[50%] bg-black w-full h-full"></div>
      <.link navigate={~p"/join"}>
        <div class="flex items-center w-60 h-40 sm:h-20 justify-center text-4xl sm:text-2xl bg-black rounded-md text-white">Join Group</div>
      </.link>
    </div>

    <.modal :if={@live_action in [:new, :join]} id="group-modal" show on_cancel={JS.patch(~p"/")}>
      <.live_component
        module={LiveScheduleWeb.GroupLive.GroupForm}
        id={:new}
        action={@live_action}
      />
    </.modal>
    """
  end
end
