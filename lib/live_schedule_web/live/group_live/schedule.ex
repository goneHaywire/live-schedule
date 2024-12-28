defmodule LiveScheduleWeb.GroupLive.Schedule do
  use LiveScheduleWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Under Construction</h1>
    """
  end
end
