defmodule LiveScheduleWeb.GroupLive.UserForm do
  use LiveScheduleWeb, :live_component

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.User

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Create User
        <:subtitle>Add a new user to the group</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-submit="submit"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Loading...">Create User</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Schedules.change_user(user))
     end)}
  end

  @impl true
  def handle_event("submit", %{"user" => user_params}, socket) do
    # TODO: get group from session
    params = Map.put(user_params, "group_id", socket.assigns.group.id)

    case Schedules.create_user(params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         # TODO: put user in session
         |> push_navigate(to: socket.assigns.patch, replace: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
