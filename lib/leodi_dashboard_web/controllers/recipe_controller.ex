defmodule LeodiDashboardWeb.RecipeController do
  use LeodiDashboardWeb, :controller

  alias LeodiDashboard.Meal
  alias LeodiDashboard.Meal.Recipe

  def index(conn, _params) do
    recipes = Meal.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Meal.change_recipe(%Recipe{})
    ingredients = Meal.list_ingredients()

    render(conn, "new.html", changeset: changeset, ingredients: ingredients)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Meal.create_recipe(recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe), ingredients: [])

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, ingredients: [])
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Meal.get_recipe!(id)
    render(conn, "show.html", recipe: recipe, ingredients: [])
  end

  def edit(conn, %{"id" => id}) do
    recipe = Meal.get_recipe!(id)
    changeset = Meal.change_recipe(recipe)
    ingredients = Meal.list_ingredients()

    render(conn, "edit.html", recipe: recipe, changeset: changeset, ingredients: ingredients)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Meal.get_recipe!(id)

    case Meal.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->

        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        ingredients = Meal.list_ingredients()
        render(conn, "edit.html", recipe: recipe, changeset: changeset, ingredients: ingredients)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Meal.get_recipe!(id)
    {:ok, _recipe} = Meal.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end
end
