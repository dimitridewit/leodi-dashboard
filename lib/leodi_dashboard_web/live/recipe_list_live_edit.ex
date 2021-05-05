defmodule LeodiDashboardWeb.RecipeListLive.Edit do
  use LeodiDashboardWeb, :live_view
  alias LeodiDashboard.List
  alias LeodiDashboard.Meal

  def render(assigns) do
    Phoenix.View.render(LeodiDashboardWeb.RecipeListView, "edit.html", assigns)
  end

  def mount(%{"id" => recipe_list_id} = params, session, socket) do
    recipe_list = List.get_recipe_list!(recipe_list_id)
    recipe_list_recipes = List.get_recipe_list_recipes!(recipe_list)

    recipes =
      Meal.list_recipes()
      |> filter_recipe_list_recipes(recipe_list_recipes)

    {
      :ok,
      socket
      |> assign(:recipe_list, recipe_list)
      |> assign(:recipe_list_recipes, recipe_list_recipes)
      |> assign(:recipes, recipes)
      |> assign(:modal_open, false)
    }
  end

  def handle_event(
        "add_recipe",
        %{
          "recipe" => %{
            "id" => recipe_id
          },
          "recipe_list" => %{
            "id" => recipe_list_id
          }
        } = _params,
        socket
      ) do
    recipe = Meal.get_recipe!(recipe_id)
    recipe_list = List.get_recipe_list!(recipe_list_id)

    List.create_recipe_list_recipe(recipe_list, recipe)

    {
      :noreply,
      fetch(socket, recipe_list.id)
      |> put_flash(:info, "Recipe added")
    }
  end

  def handle_event(
        "delete_recipe_list_recipe",
        %{
          "recipe_list" => %{
            "id" => recipe_list_id
          },
          "recipe_list_recipe" => %{
            "id" => recipe_list_recipe_id
          }
        } = params,
        socket
      ) do
    recipe_list_recipe = List.get_recipe_list_recipe!(recipe_list_recipe_id)
    {:ok, _} = List.delete_recipe_list_recipe(recipe_list_recipe)

    {
      :noreply,
      fetch(socket, recipe_list_id)
      |> put_flash(:info, "Recipe deleted")
    }
  end

  def handle_event(
        "toggle-modal",
        _params,
        %{assigns: %{modal_open: false}} = socket
      ) do
    {:noreply, socket |> assign(:modal_open, true)}
  end

  def handle_event(
        "search-recipes",
        %{"search-recipes" => search_query} = _params,
        %{assigns: %{recipes: recipes}} = socket
      ) do
    search_query = search_query |> String.downcase()

    filtered_recipes =
      recipes
      |> Enum.sort_by(
        fn recipe ->
          recipe.name
          |> String.downcase()
          |> String.contains?(search_query)
        end,
        :desc
      )

    {
      :noreply,
      socket
      |> assign(:recipes, filtered_recipes)
    }
  end

  def handle_event(
        "toggle-modal",
        _params,
        %{assigns: %{modal_open: true}} = socket
      ) do
    {:noreply, socket |> assign(:modal_open, false)}
  end

  defp filter_recipe_list_recipes(recipes, recipe_list_recipes) do
    Enum.filter(recipes, fn recipe ->
      case Enum.find(recipe_list_recipes, fn r_l_r ->
             recipe.id == r_l_r.recipe.id
           end) do
        nil -> true
        _ -> false
      end
    end)
  end

  defp fetch(socket, recipe_list_id) do
    recipe_list = List.get_recipe_list!(recipe_list_id)
    recipe_list_recipes = List.get_recipe_list_recipes!(recipe_list)

    recipes =
      Meal.list_recipes()
      |> filter_recipe_list_recipes(recipe_list_recipes)

    socket
    |> assign(:recipe_list, recipe_list)
    |> assign(:recipe_list_recipes, recipe_list_recipes)
    |> assign(:recipes, recipes)
  end
end
