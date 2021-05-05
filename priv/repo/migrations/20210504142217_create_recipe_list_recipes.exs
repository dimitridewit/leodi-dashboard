defmodule LeodiDashboard.Repo.Migrations.CreateRecipeListRecipes do
  use Ecto.Migration

  def change do
    create table(:recipe_list_recipes) do
      add :recipe_id, references(:recipes, on_delete: :restrict), primary_key: true
      add :recipe_list_id, references(:recipe_lists, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create index(:recipe_list_recipes, [:recipe_id])
    create index(:recipe_list_recipes, [:recipe_list_id])

    create unique_index(:recipe_list_recipes, [:recipe_id, :recipe_list_id],
             name: :unique_recipe_list_recipe_index
           )
  end
end
