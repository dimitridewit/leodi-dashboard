defmodule LeodiDashboard.Meal.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    belongs_to :recipe, Recipe
    belongs_to :ingredient, Ingredient

    field :amount, :string, default: "10"
    field :unit, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:recipe_id, :ingredient_id, :amount, :unit])
    |> validate_required([:recipe_id, :ingredient_id, :amount])
  end
end
