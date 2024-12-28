# Define a module to be used as base
defmodule LiveSchedule.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end

defmodule LiveSchedule.Schedules.Group do
  use LiveSchedule.Schema
  alias LiveSchedule.Schedules.User
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    has_many :users, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
