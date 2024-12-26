defmodule LiveSchedule.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:group_id])
  end
end
