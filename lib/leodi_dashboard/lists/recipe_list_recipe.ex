defmodule LeodiDashboard.List.RecipeListRecipe do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias LeodiDashboard.List.RecipeList
  alias LeodiDashboard.Meal.Recipe

  schema "recipe_list_recipes" do
    belongs_to :recipe, Recipe
    belongs_to :recipe_list, RecipeList

    timestamps()
  end

  @doc false
  def changeset(recipe_list_recipe, attrs) do
    recipe_list_recipe
    |> cast(attrs, [:recipe_id, :recipe_list_id])
    |> validate_required([:recipe_id, :recipe_list_id])
    |> unique_constraint(:recipe_id, name: :unique_recipe_list_recipe_index)
  end
end
