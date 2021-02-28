defmodule LeodiDashboard.Repo.Migrations.UpdateRecipeIngredients do
  use Ecto.Migration

  def change do
    alter table(:recipe_ingredients) do
      add :unit, :string, nil: false

      remove :grams
      remove :units
      remove :mil
    end
  end
end
