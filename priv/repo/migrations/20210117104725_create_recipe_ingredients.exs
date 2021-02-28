defmodule LeodiDashboard.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients) do
      add :recipe_id, references(:recipes, on_delete: :delete_all), primary_key: true
      add :ingredient_id, references(:ingredients, on_delete: :delete_all), primary_key: true
      add :amount, :string
      add :grams, :boolean, default: true
      add :units, :boolean, default: false
      add :mil, :boolean, default: false

      timestamps()
    end

    create(index(:recipe_ingredients, [:recipe_id]))
    create(index(:recipe_ingredients, [:ingredient_id]))
    create(
      unique_index(:recipe_ingredients, [:recipe_id, :ingredient_id])
    )
  end
end
