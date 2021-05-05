defmodule LeodiDashboard.List.RecipeList do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias LeodiDashboard.Repo
  alias LeodiDashboard.Meal.Recipe

  schema "recipe_lists" do
    many_to_many(
      :recipes,
      Recipe,
      join_through: "recipe_list_recipes",
      on_delete: :delete_all
    )

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:recipe_lists_recipe_id_fkey)
  end
end
