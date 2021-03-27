defmodule LeodiDashboardWeb.Router do
  use LeodiDashboardWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LeodiDashboardWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", LeodiDashboardWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index

    get "/recipes", RecipeController, :index
    get "/recipes/new", RecipeController, :new
    get "/recipes/:id", RecipeController, :show
    delete "/recipes/:id", RecipeController, :delete

    live "/recipes/:id/edit", RecipeLive.Edit, :edit

    resources "/ingredients", IngredientController
    resources "/recipe-ingredients", RecipeIngredientController, only: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LeodiDashboardWeb do
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
      live_dashboard "/dashboard", metrics: LeodiDashboardWeb.Telemetry
    end
  end
end
