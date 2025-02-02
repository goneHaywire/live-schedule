defmodule LiveScheduleWeb.UserAuth do
  use LiveScheduleWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias LiveSchedule.Accounts

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_live_schedule_web_user_remember_me"
  @joined_group_cookie "_live_schedule_web_joined_group"
  @selected_user_cookie "_live_schedule_web_selected_user"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  # def join_group(conn, params \\ %{}) do
  #   user_return_to = get_session(conn, :user_return_to)
  #
  #   conn
  #   |> renew_session()
  #   |> put_group_in_session(conn.params["group_id"])
  #   # |> maybe_write_remember_me_cookie(token, params)
  #   |> redirect(to: user_return_to || joined_group_path(conn))
  # end

  def select_user(conn, params \\ %{}) do
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> put_user_in_session(params.user_id)
    # |> maybe_write_remember_me_cookie(token, params)
    # |> redirect(to: user_return_to || selected_user_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def leave_group(conn) do
    group = get_session(conn, :joined_group)

    if live_socket_id = get_session(conn, :live_socket_id) do
      LiveScheduleWeb.Endpoint.broadcast(live_socket_id, "leave_group", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@joined_group_cookie)
    |> redirect(to: join_group_path(conn))
  end
  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def deselect_user(conn) do
    user = get_session(conn, :selected_user)

    if live_socket_id = get_session(conn, :live_socket_id) do
      LiveScheduleWeb.Endpoint.broadcast(live_socket_id, "deselect_user", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@selected_user_cookie)
    |> redirect(to: select_user_path(conn))
  end

  @doc """
  Authenticates the user by looking into the session
  """
  def fetch_selected_user(conn, _opts) do
    assign(conn, :selected_user, get_session(conn, :selected_user))
  end

  def fetch_joined_group(%{:params => %{"group_id" => group_id }} = conn, _opts) do
    conn = case Ecto.UUID.cast(group_id) do
      {:ok, group} -> put_group_in_session(conn, group)
      :error -> conn
    end
    assign(conn, :joined_group, get_session(conn, :joined_group))
  end

  def fetch_joined_group(conn, _opts) do
    assign(conn, :joined_group, get_session(conn, :joined_group))
  end

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_selected_user` - Assigns current_user
      to socket assigns based on user_token, or nil if
      there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session,
      and assigns the current_user to socket assigns based
      on user_token.
      Redirects to login page if there's no logged user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the session.
      Redirects to signed_in_path if there's a logged user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule LiveScheduleWeb.PageLive do
        use LiveScheduleWeb, :live_view

        on_mount {LiveScheduleWeb.UserAuth, :mount_selected_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{LiveScheduleWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """

  def on_mount(:mount_joined_group, _params, session, socket) do
    {:cont, mount_joined_group(socket, session)}
  end

  def on_mount(:mount_selected_user, _params, session, socket) do
    {:cont, mount_selected_user(socket, session)}
  end

  def on_mount(:ensure_group_joined_and_user_selected, _params, session, socket) do
    with {:cont, socket} <- on_mount(:ensure_group_joined, _params, session, socket),
         {:cont, socket} <- on_mount(:ensure_user_selected, _params, session, socket)
    do 
      {:cont, socket}
    else
      _ -> {:halt, socket}
    end
  end

  def on_mount(:ensure_group_joined, _params, session, socket) do
    socket = mount_joined_group(socket, session)

    if socket.assigns.joined_group do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must join a group to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end

  def on_mount(:ensure_user_selected, _params, session, socket) do
    socket = mount_selected_user(socket, session)

    if socket.assigns.selected_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must select a user to access this page.")
        |> Phoenix.LiveView.redirect(to: select_user_path(socket))

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_has_joined_group, _params, session, socket) do
    socket = mount_joined_group(socket, session)

    if socket.assigns.joined_group do
      {:halt, Phoenix.LiveView.redirect(socket, to: joined_group_path(socket))}
    else
      {:cont, socket}
    end
  end

  def on_mount(:redirect_if_user_is_selected, _params, session, socket) do
    socket = mount_selected_user(socket, session)

    if socket.assigns.selected_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: selected_user_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_joined_group(socket, session) do
    Phoenix.Component.assign_new(socket, :joined_group, fn ->
      if group = session["joined_group"] do
        group 
      end
    end)
  end

  defp mount_selected_user(socket, session) do
    Phoenix.Component.assign_new(socket, :selected_user, fn ->
      if user = session["selected_user"] do
        user
      end
    end)
  end

  @doc """
  Used for routes that require the user have joined a group.
  """
  def redirect_if_user_has_joined_group(conn, _opts) do
    if conn.assigns.joined_group do
      conn
      |> redirect(to: joined_group_path(conn))
      |> halt()
    else
      conn
    end
  end

  def require_joined_group(conn, _opts) do
    if conn.assigns[:joined_group] do
      conn
    else
      conn
      |> put_flash(:error, "You must join a group to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_selected_user(conn, _opts) do
    if conn.assigns[:selected_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must select a user to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: select_user_path(conn))
      |> halt()
    end
  end

  # defp put_token_in_session(conn, token) do
  #   conn
  #   |> put_session(:user_token, token)
  #   |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  # end

  defp put_user_in_session(conn, user) do
    conn
    |> put_session(:selected_user, user)
  end

  defp put_group_in_session(conn, group) do
    conn
    |> put_session(:joined_group, group)
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp join_group_path(conn), do: ~p"/"
  defp select_user_path(conn), do: ~p"/#{conn.assigns.joined_group}"

  defp joined_group_path(conn), do: ~p"/#{conn.assigns.joined_group}"
  def selected_user_path(conn), do: ~p"/schedule"
end
