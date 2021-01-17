defmodule LeodiDashboard.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :url, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:recipes, [:name])
  end
end
