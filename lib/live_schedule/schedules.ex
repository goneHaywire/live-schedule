defmodule LiveSchedule.Schedules do
  @moduledoc """
  The Schedules context.
  """

  import Ecto.Query, warn: false
  alias LiveSchedule.Repo

  alias LiveSchedule.Schedules.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  ## Examples

      iex> get_group(123)
      %Group{}

      iex> get_group(456)
      nil

  """
  def get_group(id), do: Repo.get(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  alias LiveSchedule.Schedules.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias LiveSchedule.Schedules.AvailableDate

  @doc """
  Returns the list of available_dates.

  ## Examples

      iex> list_available_dates()
      [%AvailableDate{}, ...]

  """
  def list_available_dates do
    Repo.all(AvailableDate)
  end

  @doc """
  Gets a single available_date.

  ## Examples

      iex> get_available_date(123)
      %AvailableDate{}

      iex> get_available_date(456)
      nil

  """
  def get_available_date(id), do: Repo.get(AvailableDate, id)

  @doc """
  Creates a available_date.

  ## Examples

      iex> create_available_date(%{field: value})
      {:ok, %AvailableDate{}}

      iex> create_available_date(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_available_date(attrs \\ %{}) do
    %AvailableDate{}
    |> AvailableDate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a available_date.

  ## Examples

      iex> update_available_date(available_date, %{field: new_value})
      {:ok, %AvailableDate{}}

      iex> update_available_date(available_date, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_available_date(%AvailableDate{} = available_date, attrs) do
    available_date
    |> AvailableDate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a available_date.

  ## Examples

      iex> delete_available_date(available_date)
      {:ok, %AvailableDate{}}

      iex> delete_available_date(available_date)
      {:error, %Ecto.Changeset{}}

  """
  def delete_available_date(%AvailableDate{} = available_date) do
    Repo.delete(available_date)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking available_date changes.

  ## Examples

      iex> change_available_date(available_date)
      %Ecto.Changeset{data: %AvailableDate{}}

  """
  def change_available_date(%AvailableDate{} = available_date, attrs \\ %{}) do
    AvailableDate.changeset(available_date, attrs)
  end
end
