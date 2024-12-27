defmodule LiveScheduleWeb.GroupLive.FormComponent do
  use LiveScheduleWeb, :live_component

  alias LiveSchedule.Schedules
  alias LiveSchedule.Schedules.Group

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {if @action == :new, do: "Create Group", else: "Join Group"}
        <:subtitle>{if @action == :new, do: "Enter a new group name", else: "Enter a group id to join"}</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="group-form"
        phx-target={@myself}
        phx-submit="submit"
      >
        <.input field={@form[:name]} type="text" label={if @action == :new, do: "Name", else: "Group ID"} />
        <:actions>
          <.button phx-disable-with="Loading...">{if @action == :new, do: "Create", else: "Join"}</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{group: group} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Schedules.change_group(group))
     end)}
  end

  def handle_event("submit", %{"group" => group_params}, socket) do
    submit_group(socket, socket.assigns.action, group_params)
  end

  defp submit_group(socket, :join, %{"name" => group} = params) do
    with true <- String.length(group) == 36,
         %Group{} = group <- Schedules.get_group(group) 
    do
      {:noreply, push_navigate(socket, to: ~p"/#{group.id}")}
    else
      _ ->
        changeset = %Group{}
        |> Group.changeset(params)
        |> Map.put(:action, :insert)
        |> Ecto.Changeset.add_error(:name, "Group not found")

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp submit_group(socket, :new, group_params) do
    case Schedules.create_group(group_params) do
      {:ok, group} ->

        {:noreply,
         socket
         |> put_flash(:info, "Group created successfully")
         |> push_navigate(to: ~p"/#{group.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
