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
    |> put_assoc(:ingredients, load_ingredients(attrs))
    |> validate_required([:name, :url, :description])
    |> unique_constraint(:name)
  end

  def load_ingredients(params) do
    IO.inspect params
    case params["ingredients"] || [] do
      [] -> []
      ids ->
        Repo.all(
          from i in Ingredient,
          where: i.id in ^ids
        )
    end
  end
end
