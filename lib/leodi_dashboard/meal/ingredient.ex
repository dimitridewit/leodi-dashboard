defmodule LeodiDashboard.Meal.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias LeodiDashboard.Meal.Recipe
  alias LeodiDashboard.Meal.RecipeIngredient

  schema "ingredients" do
    many_to_many(
      :recipes,
      Recipe,
      join_through: RecipeIngredient
    )

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
