defmodule LiveSchedule.Schedules.User do
  use LiveSchedule.Schema
  import Ecto.Changeset
  alias LiveSchedule.Schedules.Group
  alias LiveSchedule.Schedules.AvailableDate

  schema "users" do
    field :name, :string
    belongs_to :group, Group
    has_many :available_dates, AvailableDate

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :group_id])
    |> validate_required([:name, :group_id])
  end
end
