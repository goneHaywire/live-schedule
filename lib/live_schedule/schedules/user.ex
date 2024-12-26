defmodule LiveSchedule.Schedules.User do
  use LiveSchedule.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :group_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :group_id])
    |> validate_required([:name, :group_id])
  end
end
