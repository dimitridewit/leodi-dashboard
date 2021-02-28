defmodule LeodiDashboardWeb.RecipeIngredientController do
  use LeodiDashboardWeb, :controller

  alias LeodiDashboard.Meal

  def delete(conn, %{"id" => id}) do
    ingredient = Meal.get_recipe_ingredient!(id)
    {:ok, _ingredient} = Meal.delete_recipe_ingredient(ingredient)

    conn
    |> put_flash(:info, "Ingredient deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end
end
