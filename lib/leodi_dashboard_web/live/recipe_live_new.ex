defmodule LeodiDashboardWeb.RecipeLive.New do
  use LeodiDashboardWeb, :live_view
  alias LeodiDashboardWeb.Endpoint
  alias LeodiDashboard.Meal
  alias LeodiDashboard.Meal.Recipe

  def render(assigns) do
    Phoenix.View.render(LeodiDashboardWeb.RecipeView, "new.html", assigns)
  end

  def mount(params, session, socket) do
    recipe = Meal.change_recipe(%Recipe{})
    ingredients = Meal.list_ingredients()

    {
      :ok,
      socket
      |> assign(:changeset, recipe)
      |> assign(:ingredients, ingredients)
    }
  end

  def handle_event("create", %{"recipe" => params}, socket) do
    case Meal.create_recipe(params) do
      {:ok, recipe = %Recipe{}} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Recipe created successfully")
          |> redirect(to: Routes.recipe_edit_path(Endpoint, :edit, recipe))
        }

      {:error, changeset} ->
        {
          :noreply,
          assign(socket, changeset: changeset)
        }
    end
  end
end
