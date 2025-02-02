defmodule LiveScheduleWeb.Router do
  use LiveScheduleWeb, :router

  import LiveScheduleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveScheduleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_joined_group
    plug :fetch_selected_user
  end

  pipeline :require_group do
    plug :browser
    plug :require_joined_group
  end

  pipeline :require_user do
    plug :require_group
    plug :require_selected_user
  end

  # must have joined a group and selected a user as well
  scope "/", LiveScheduleWeb do
    pipe_through :require_user
    
    live_session :require_user,
      layout: {LiveScheduleWeb.Layouts, :schedule},
      on_mount: [{LiveScheduleWeb.UserAuth, :ensure_group_joined_and_user_selected}] do
      live "/schedule", GroupLive.Schedule
    end

    delete "/deselect_user", UserSessionController, :deselect_user
  end

  # user must not have joined a group
  scope "/", LiveScheduleWeb do
    pipe_through [:browser, :redirect_if_user_has_joined_group]

    live_session :redirect_if_user_has_joined_group,
      on_mount: [{LiveScheduleWeb.UserAuth, :redirect_if_user_has_joined_group}] do
        live "/", GroupLive.Index, :index
        live "/new", GroupLive.Index, :new
        live "/join", GroupLive.Index, :join
      end
  end

  # must have joined a group
  scope "/", LiveScheduleWeb do
    pipe_through :require_group

    live_session :require_group,
      on_mount: [{LiveScheduleWeb.UserAuth, :ensure_group_joined}] do
      live "/:group_id", GroupLive.Show, :show
      live "/:group_id/show/edit", GroupLive.Show, :edit
      live "/:group_id/add_user", GroupLive.Show, :add_user

    end

    post "/select_user", UserSessionController, :select_user
    post "/select_user/:user_id", UserSessionController, :select_user
    delete "/leave_group", UserSessionController, :leave_group
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveScheduleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_schedule, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveScheduleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
