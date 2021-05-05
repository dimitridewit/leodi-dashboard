defmodule LeodiDashboardWeb.PageController do
  use LeodiDashboardWeb, :controller

  alias LeodiDashboard.List
  alias LeodiDashboard.Meal

  def index(conn, _params) do
    recipes = Meal.list_recipes()
    recipe_lists = List.list_recipe_lists()

    render(conn, "index.html", recipes: recipes, recipe_lists: recipe_lists)
  end
end
