defmodule LiveScheduleWeb.Router do
  use LiveScheduleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveScheduleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveScheduleWeb do
    pipe_through :browser

    live "/", GroupLive.Index, :index
    live "/new", GroupLive.Index, :new
    live "/join", GroupLive.Index, :join

    live "/:group_id", GroupLive.Show, :show
    live "/:group_id/schedule", GroupLive.Schedule
    live "/:group_id/show/edit", GroupLive.Show, :edit
    live "/:group_id/add_user", GroupLive.Show, :add_user
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
