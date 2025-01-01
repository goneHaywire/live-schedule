defmodule LiveScheduleWeb.CustomComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.HTML
  alias LiveSchedule.Schedules.User

  attr :user, User, required: false
  attr :navigate, :string, required: true
  attr :rest, :global

  def user_card(assigns) do
    # TODO: shorten the name if too long
    username = if assigns.user, do: assigns.user.name, else: nil
    assigns = assigns
    |> Map.put(:username, username)

    ~H"""
    <.link class="border rounded-md flex flex-col items-center justify-center h-32 cursor-pointer" navigate={@navigate} phx-click="schedule">
      <img src={if @user, do: "/images/profile.svg", else: "/images/add-profile.svg"} class="w-20" />
      <div class="font-semibold line-clamp-1">{if @user, do: @username, else: "Your name here" }</div>
    </.link>
    """ 
  end
end
