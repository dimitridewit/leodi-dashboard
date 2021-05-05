defmodule LeodiDashboard.List do
  import Ecto.Query, warn: false
  alias LeodiDashboard.Repo

  alias LeodiDashboard.Meal.Recipe
  alias LeodiDashboard.List.RecipeList
  alias LeodiDashboard.List.RecipeListRecipe

  def list_recipe_lists do
    Repo.all(RecipeList)
  end

  def get_recipe_list!(id) do
    q =
      from(
        i in Recipe,
        join: r in "recipes",
        on: i.id == r.id
      )

    Repo.one(
      from r in RecipeList,
        preload: [recipes: ^q],
        where: r.id == ^id
    )
  end

  def get_recipe_list_recipe!(id) do
    Repo.get!(RecipeListRecipe, id)
  end

  def get_recipe_list_recipes!(%RecipeList{id: id} = recipe_list) do
    q =
      from(
        r in Recipe,
        join: r_l_r in "recipe_list_recipes",
        on: r_l_r.recipe_id == r.id
      )

    Repo.all(
      from r_l_r in RecipeListRecipe,
        preload: [recipe: ^q],
        where: r_l_r.recipe_list_id == ^id
    )
  end

  def create_recipe_list(attrs \\ %{}) do
    %RecipeList{}
    |> RecipeList.changeset(attrs)
    |> Repo.insert()
  end

  def create_recipe_list_recipe(%RecipeList{} = recipe_list, %Recipe{} = recipe) do
    attrs = %{"recipe_id" => recipe.id, "recipe_list_id" => recipe_list.id}

    %RecipeListRecipe{}
    |> RecipeListRecipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe_list(%RecipeList{} = recipe_list, attrs) do
    recipe_list
    |> RecipeList.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe_list(%RecipeList{} = recipe_list) do
    Repo.delete(recipe_list)
  end

  def change_recipe_list(%RecipeList{} = recipe_list, attrs \\ %{}) do
    RecipeList.changeset(recipe_list, attrs)
  end

  def delete_recipe_list_recipe(%RecipeListRecipe{} = recipe_list_recipe) do
    Repo.delete(recipe_list_recipe)
  end
end
