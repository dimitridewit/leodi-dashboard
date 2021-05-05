defmodule LeodiDashboardWeb.RecipeListController do
  use LeodiDashboardWeb, :controller

  alias LeodiDashboard.List
  alias LeodiDashboard.Lists.RecipeList

  def index(conn, _params) do
    recipe_lists = List.list_recipe_lists()
    render(conn, "index.html", recipe_lists: recipe_lists)
  end

  def show(conn, %{"id" => id}) do
    recipe_list = List.get_recipe_list!(id)

    render(
      conn,
      "show.html",
      recipe_list: recipe_list
    )
  end

  def delete(conn, %{"id" => id}) do
    recipe_list = List.get_recipe_list!(id)
    {:ok, _recipe_list} = List.delete_recipe_list(recipe_list)

    conn
    |> put_flash(:info, "RecipeList deleted successfully.")
    |> redirect(to: Routes.recipe_list_path(conn, :index))
  end
end
