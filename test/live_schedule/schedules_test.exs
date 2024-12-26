defmodule LiveSchedule.SchedulesTest do
  use LiveSchedule.DataCase

  alias LiveSchedule.Schedules

  describe "groups" do
    alias LiveSchedule.Schedules.Group

    import LiveSchedule.SchedulesFixtures

    @invalid_attrs %{name: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Schedules.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Schedules.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Group{} = group} = Schedules.create_group(valid_attrs)
      assert group.name == "some name"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Group{} = group} = Schedules.update_group(group, update_attrs)
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_group(group, @invalid_attrs)
      assert group == Schedules.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Schedules.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Schedules.change_group(group)
    end
  end

  describe "users" do
    alias LiveSchedule.Schedules.User

    import LiveSchedule.SchedulesFixtures

    @invalid_attrs %{}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Schedules.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Schedules.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{}

      assert {:ok, %User{} = user} = Schedules.create_user(valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{}

      assert {:ok, %User{} = user} = Schedules.update_user(user, update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_user(user, @invalid_attrs)
      assert user == Schedules.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Schedules.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Schedules.change_user(user)
    end
  end

  describe "available_dates" do
    alias LiveSchedule.Schedules.AvailableDate

    import LiveSchedule.SchedulesFixtures

    @invalid_attrs %{}

    test "list_available_dates/0 returns all available_dates" do
      available_date = available_date_fixture()
      assert Schedules.list_available_dates() == [available_date]
    end

    test "get_available_date!/1 returns the available_date with given id" do
      available_date = available_date_fixture()
      assert Schedules.get_available_date!(available_date.id) == available_date
    end

    test "create_available_date/1 with valid data creates a available_date" do
      valid_attrs = %{}

      assert {:ok, %AvailableDate{} = available_date} = Schedules.create_available_date(valid_attrs)
    end

    test "create_available_date/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_available_date(@invalid_attrs)
    end

    test "update_available_date/2 with valid data updates the available_date" do
      available_date = available_date_fixture()
      update_attrs = %{}

      assert {:ok, %AvailableDate{} = available_date} = Schedules.update_available_date(available_date, update_attrs)
    end

    test "update_available_date/2 with invalid data returns error changeset" do
      available_date = available_date_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_available_date(available_date, @invalid_attrs)
      assert available_date == Schedules.get_available_date!(available_date.id)
    end

    test "delete_available_date/1 deletes the available_date" do
      available_date = available_date_fixture()
      assert {:ok, %AvailableDate{}} = Schedules.delete_available_date(available_date)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_available_date!(available_date.id) end
    end

    test "change_available_date/1 returns a available_date changeset" do
      available_date = available_date_fixture()
      assert %Ecto.Changeset{} = Schedules.change_available_date(available_date)
    end
  end
end
