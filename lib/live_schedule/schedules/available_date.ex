defmodule LiveSchedule.Schedules.AvailableDate do
  use LiveSchedule.Schema
  import Ecto.Changeset

  schema "available_dates" do
    field :date, :date
    field :user_id, :binary_id

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
