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

  attr :first, :boolean, default: false
  slot :inner_block, required: true

  def nav_btn(assigns) do
    first_btn_classes = if assigns.first, do: "sm:rounded-lg sm:text-zinc-900 sm:bg-zinc-100 sm:hover:bg-zinc-200 sm:px-4 sm:py-1", else: "sm:px-4 sm:py-1"
    assigns = assigns
    |> Map.put(:first_btn_classes, first_btn_classes)

    ~H"""
    <.link class={"#{@first_btn_classes}"} navigate={@navigate}>
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
