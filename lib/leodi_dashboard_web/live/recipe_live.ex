defmodule LeodiDashboardWeb.RecipeLive.Edit do
  use LeodiDashboardWeb, :live_view
  alias LeodiDashboard.Meal

  def render(assigns) do
   Phoenix.View.render(LeodiDashboardWeb.RecipeView, "edit.html", assigns)
  end

  def mount(%{"id" => recipe_id} = params, session, socket) do
    recipe = Meal.get_recipe!(recipe_id)
    recipe_ingredients = Meal.get_recipe_ingredients!(recipe)
    ingredients =
      Meal.list_ingredients()
      |> filter_recipe_ingredients(recipe_ingredients)

    {
      :ok,
      socket
      |> assign(:recipe, recipe)
      |> assign(:recipe_ingredients, recipe_ingredients)
      |> assign(:ingredients, ingredients)
    }
  end

  def handle_event("update_recipe", %{"recipe" => %{"id" => recipe_id} = params}, socket) do
    recipe = Meal.get_recipe!(recipe_id)

    Meal.update_recipe(recipe, params)

    {:noreply, fetch(socket, recipe.id)}
  end

  def handle_event(
    "add_recipe_ingredient",
    %{
      "recipe" => %{
        "id" => recipe_id,
        "ingredient_id" => ingredient_id
      },
      "recipe_ingredient" => attrs
    } = params,
    socket
  ) do
    recipe = Meal.get_recipe!(recipe_id)
    ingredient = Meal.get_ingredient!(ingredient_id)

    Meal.create_recipe_ingredient(recipe, ingredient, attrs)

    {:noreply, fetch(socket, recipe.id) |> put_flash(:info, "Ingredient added")}
  end

  def handle_event(
    "delete_recipe_ingredient",
    %{
      "recipe" => %{
        "id" => recipe_id,
        "recipe_ingredient_id" => recipe_ingredient_id
      }
    } = _params,
    socket
  ) do
    ingredient = Meal.get_recipe_ingredient!(recipe_ingredient_id)
    {:ok, _ingredient} = Meal.delete_recipe_ingredient(ingredient)

    {
      :noreply,
      fetch(socket, recipe_id)
    }
  end

  defp filter_recipe_ingredients(ingredients, recipe_ingredients) do
    Enum.filter(ingredients, fn ingredient ->
      case Enum.find(recipe_ingredients, fn r_i ->
        ingredient.id == r_i.ingredient.id
      end) do
        nil -> true
        _ -> false
      end
    end)
  end

  defp fetch(socket, recipe_id) do
    recipe = Meal.get_recipe!(recipe_id)
    recipe_ingredients = Meal.get_recipe_ingredients!(recipe)
    ingredients =
      Meal.list_ingredients()
      |> filter_recipe_ingredients(recipe_ingredients)

    socket
    |> assign(:recipe, Meal.get_recipe!(recipe_id))
    |> assign(:recipe_ingredients, recipe_ingredients)
    |> assign(:ingredients, ingredients)
  end
end
