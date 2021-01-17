defmodule LeodiDashboard.Meal.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    belongs_to :recipe, Recipe, primary_key: true
    belongs_to :ingredient, Ingredient, primary_key: true

    field :amount, :string, default: "10"
    field :grams, :boolean, default: true
    field :units, :boolean, default: false
    field :mil, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:recipe_id, :ingredient_id, :amount, :grams, :units, :mil])
    |> validate_required([:recipe_id, :ingredient_id])
  end
end
