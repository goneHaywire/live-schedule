defmodule LiveSchedule.Repo do
  use Ecto.Repo,
    otp_app: :live_schedule,
    adapter: Ecto.Adapters.Postgres
end
