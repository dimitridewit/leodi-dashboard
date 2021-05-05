defmodule LeodiDashboard.Repo.Migrations.CreateRecipeLists do
  use Ecto.Migration

  def change do
    create table(:recipe_lists) do
      add :name, :string, nil: false

      timestamps()
    end

    create unique_index(:recipe_lists, [:name])
  end
end
