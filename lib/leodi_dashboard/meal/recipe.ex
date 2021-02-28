defmodule LeodiDashboard.Meal.Recipe do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias LeodiDashboard.Repo

  alias LeodiDashboard.Meal.RecipeIngredient
  alias LeodiDashboard.Meal.Ingredient

  schema "recipes" do
    many_to_many(
      :ingredients,
      Ingredient,
      join_through: RecipeIngredient, on_replace: :delete
    )

    field :description, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :url, :description])
    |> validate_required([:name, :url, :description])
    |> foreign_key_constraint(:recipe_ingredients_recipe_id_fkey)
    |> unique_constraint(:name)
  end
end
