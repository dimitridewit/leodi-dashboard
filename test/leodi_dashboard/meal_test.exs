defmodule LeodiDashboard.MealTest do
  use LeodiDashboard.DataCase

  alias LeodiDashboard.Meal

  describe "recipes" do
    alias LeodiDashboard.Meal.Recipe

    @valid_attrs %{description: "some description", name: "some name", url: "some url"}
    @update_attrs %{description: "some updated description", name: "some updated name", url: "some updated url"}
    @invalid_attrs %{description: nil, name: nil, url: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meal.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Meal.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Meal.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Meal.create_recipe(@valid_attrs)
      assert recipe.description == "some description"
      assert recipe.name == "some name"
      assert recipe.url == "some url"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meal.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{} = recipe} = Meal.update_recipe(recipe, @update_attrs)
      assert recipe.description == "some updated description"
      assert recipe.name == "some updated name"
      assert recipe.url == "some updated url"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Meal.update_recipe(recipe, @invalid_attrs)
      assert recipe == Meal.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Meal.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Meal.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Meal.change_recipe(recipe)
    end
  end

  describe "ingredients" do
    alias LeodiDashboard.Meal.Ingredient

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def ingredient_fixture(attrs \\ %{}) do
      {:ok, ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meal.create_ingredient()

      ingredient
    end

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Meal.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Meal.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{} = ingredient} = Meal.create_ingredient(@valid_attrs)
      assert ingredient.name == "some name"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meal.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{} = ingredient} = Meal.update_ingredient(ingredient, @update_attrs)
      assert ingredient.name == "some updated name"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Meal.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Meal.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Meal.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Meal.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Meal.change_ingredient(ingredient)
    end
  end
end
