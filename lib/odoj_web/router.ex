defmodule OdojWeb.Router do
  use OdojWeb, :router

  import OdojWeb.MemberAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OdojWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_member
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OdojWeb do
    pipe_through [:browser, :require_authenticated_member]

    live "/catat", TrackerLive, :index
    live "/rekap", ListLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", OdojWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: OdojWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", OdojWeb do
    pipe_through [:browser, :redirect_if_member_is_authenticated]

    get "/members/register", MemberRegistrationController, :new
    post "/members/register", MemberRegistrationController, :create
    get "/", MemberSessionController, :index
    get "/members/log_in", MemberSessionController, :new
    post "/members/log_in", MemberSessionController, :create
    get "/members/reset_password", MemberResetPasswordController, :new
    post "/members/reset_password", MemberResetPasswordController, :create
    get "/members/reset_password/:token", MemberResetPasswordController, :edit
    put "/members/reset_password/:token", MemberResetPasswordController, :update
  end

  scope "/", OdojWeb do
    pipe_through [:browser, :require_authenticated_member]

    get "/members/settings", MemberSettingsController, :edit
    put "/members/settings", MemberSettingsController, :update
    get "/members/settings/confirm_email/:token", MemberSettingsController, :confirm_email
  end

  scope "/", OdojWeb do
    pipe_through [:browser]

    delete "/members/log_out", MemberSessionController, :delete
    get "/members/confirm", MemberConfirmationController, :new
    post "/members/confirm", MemberConfirmationController, :create
    get "/members/confirm/:token", MemberConfirmationController, :confirm
  end
end

