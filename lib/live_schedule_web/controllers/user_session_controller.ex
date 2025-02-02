defmodule LiveScheduleWeb.UserSessionController do
  use LiveScheduleWeb, :controller

  alias LiveScheduleWeb.UserAuth

  # INFO: this handles the event triggered by js
  # def select_user(conn, %{"_json" => user_id}) do
  #   # IO.inspect(user_id)
  #   conn = conn
  #   |> put_flash(:info, "You can now schedule your dates!")
  #   |> UserAuth.select_user(%{user_id: user_id})
  #   IO.inspect(conn)
  #   conn
  # end

  def select_user(conn, %{"user_id" => user_id}) do
    conn
    |> put_flash(:info, "You can now schedule your dates!")
    |> UserAuth.select_user(%{user_id: user_id})
    |> redirect(to: UserAuth.selected_user_path(conn))
  end

  def deselect_user(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.deselect_user()
  end

  def leave_group(conn, _params) do
    conn
    |> put_flash(:info, "Left group successfully.")
    |> UserAuth.leave_group()
  end
end
