defmodule LiveSchedule.Schedules.AvailableDate do
  use LiveSchedule.Schema
  import Ecto.Changeset
  alias LiveSchedule.Schedules.User

  schema "available_dates" do
    field :date, :date
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(available_date, attrs) do
    # TODO: validate date is in the future
    available_date
    |> cast(attrs, [:date, :user_id])
    |> validate_required([:date, :user_id])
  end
end
