defmodule LiveScheduleWeb.CustomComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.HTML
  alias LiveSchedule.Schedules.User

  attr :user, User, required: false
  attr :navigate, :string, required: true
  attr :rest, :global
  attr :disabled, :boolean, default: false
  attr :selected, :boolean, default: false

  def user_card(assigns) do
    # TODO: shorten the name if too long
    username = if assigns.user, do: assigns.user.name, else: nil
    assigns = assigns
    |> Map.put(:username, username)

    ~H"""
    <%= if @user do %>
      <%= if @disabled do %>
        <div class={"shadow-md rounded-md flex flex-col items-center justify-center h-32 cursor-pointer #{if @selected, do: "border-accent-light border-2"}"}>
          <img src={"/images/profile.svg"} class="w-20" />
          <div class="font-semibold line-clamp-1">{@username}</div>
        </div>
      <% else %>
        <.link class={"shadow-md rounded-md flex flex-col items-center justify-center h-32 cursor-pointer #{if @selected, do: "border-red-100"}"} href={@navigate} method="post">
          <img src={"/images/profile.svg"} class="w-20" />
          <div class="font-semibold line-clamp-1">{@username}</div>
        </.link>
      <% end %>
    <% else %>
      <.link class="shadow-md rounded-md flex flex-col items-center justify-center h-32 cursor-pointer" navigate={@navigate}>
        <img src={"/images/add-profile.svg"} class="w-20" />
        <div class="font-semibold line-clamp-1">Your name here</div>
      </.link>
    <% end %>
    """ 
  end
  
  attr :user, User, required: true
  def user_row(assigns) do

    ~H"""
    <div class="text-main-dark bg-white min-h-10 px-2 mt-3 first:mt-0 sm:min-h-16 border rounded-md flex items-center sm:px-4 sm:mt-5">
      <img src={"/images/profile.svg"} class="w-6 mr-2 sm:w-8 sm:mr-4" />
      {@user.name}
      &nbsp;<p class="italic text-main"> is offline.</p>
    </div>
    """
  end

  attr :primary, :boolean, default: false
  slot :inner_block, required: true

  def nav_btn(assigns) do
    primary_btn_classes = if assigns.primary, do: "text-accent sm:text-white sm:bg-accent sm:hover:bg-accent-light", else: "text-white-dark sm:text-black sm:bg-white-dark sm:hover:bg-white"
    assigns = assigns
    |> Map.put(:primary_btn_classes, primary_btn_classes)

    ~H"""
    <.link class={"#{@primary_btn_classes} sm:px-4 sm:py-1 sm:rounded-lg "} navigate={@navigate}>
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
