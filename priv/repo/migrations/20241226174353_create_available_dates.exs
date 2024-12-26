defmodule LiveSchedule.Repo.Migrations.CreateAvailableDates do
  use Ecto.Migration

  def change do
    create table(:available_dates) do
      add :date, :date
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:available_dates, [:user_id])
  end
end
