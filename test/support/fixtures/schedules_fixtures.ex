defmodule LiveSchedule.SchedulesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSchedule.Schedules` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LiveSchedule.Schedules.create_group()

    group
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> LiveSchedule.Schedules.create_user()

    user
  end

  @doc """
  Generate a available_date.
  """
  def available_date_fixture(attrs \\ %{}) do
    {:ok, available_date} =
      attrs
      |> Enum.into(%{

      })
      |> LiveSchedule.Schedules.create_available_date()

    available_date
  end
end
