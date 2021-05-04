defmodule LeodiDashboard.Meal do
  @moduledoc """
  The Meal context.
  """

  import Ecto.Query, warn: false
  alias LeodiDashboard.Repo
  alias LeodiDashboard.Shared.Type

  alias LeodiDashboard.Meal.Recipe
  alias LeodiDashboard.Meal.Ingredient
  alias LeodiDashboard.Meal.RecipeIngredient

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{ingredients: %Eco.Association.NotLoaded{}}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id) do
    q =
      from(
        i in Ingredient,
        join: r_i in "recipe_ingredients",
        on: i.id == r_i.ingredient_id
      )

    Repo.one(
      from r in Recipe,
        preload: [ingredients: ^q],
        where: r.id == ^id
    )
  end

  # query = from(m in Movie, join: a in assoc(m, :actors), preload: [actors: a])

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def create_recipe_with_ingredients(%{"ingredients" => ingredients} = attrs) do
    recipe_changeset = change_recipe(%Recipe{}, Map.delete(attrs, "ingredients"))

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:recipe, recipe_changeset)
    |> Ecto.Multi.run(:recipe_ingredients, fn Repo, %{recipe: recipe} ->
      timestamp =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      recipe_ingredients =
        Enum.map(ingredients, fn {ingredient_id, recipe_ingredient_attrs} ->
          Map.merge(recipe_ingredient_attrs, %{
            recipe_id: recipe.id,
            ingredient_id: Type.to_integer(ingredient_id),
            inserted_at: timestamp,
            updated_at: timestamp
          })
        end)

      {count, _} = Repo.insert_all(RecipeIngredient, recipe_ingredients, on_conflict: :nothing)
      {:ok, count}
    end)
    |> Repo.transaction()
  end

  def create_recipe_with_ingredients(attrs) do
    create_recipe(attrs)
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a recipe and its ingredients
  """
  def update_recipe_with_ingredients(
        %Recipe{id: recipe_id} = recipe,
        %{"ingredients" => ingredients} = attrs
      ) do
    recipe_changeset = change_recipe(recipe, Map.delete(attrs, "ingredients"))

    Ecto.Multi.new()
    |> Ecto.Multi.update(:recipe, recipe_changeset)
    |> Ecto.Multi.run(:recipe_ingredients, fn Repo, %{recipe: recipe} ->
      timestamp =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      recipe_ingredients =
        Enum.map(ingredients, fn {ingredient_id, recipe_ingredient_attrs} ->
          %{
            amount: recipe_ingredient_attrs["amount"],
            recipe_id: recipe.id,
            ingredient_id: Type.to_integer(ingredient_id),
            inserted_at: timestamp,
            updated_at: timestamp
          }
        end)

      {count, _} =
        Repo.insert_all(
          RecipeIngredient,
          recipe_ingredients,
          on_conflict: :nothing
        )

      {:ok, count}
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

      iex> get_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{data: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient, attrs \\ %{}) do
    Ingredient.changeset(ingredient, attrs)
  end

  @doc """
  Gets a single recipe ingredient.
  """
  def get_recipe_ingredient!(%Recipe{} = recipe, %Ingredient{} = ingredient) do
    Repo.get!(RecipeIngredient, recipe, ingredient)
  end

  def get_recipe_ingredient!(id) do
    Repo.get!(RecipeIngredient, id)
  end

  @doc """
  Gets all recipe ingredients for a specific recipe.
  """
  def get_recipe_ingredients!(%Recipe{id: id} = recipe) do
    q =
      from(
        i in Ingredient,
        join: r_i in "recipe_ingredients",
        on: r_i.ingredient_id == i.id
      )

    Repo.all(
      from r_i in RecipeIngredient,
        preload: [ingredient: ^q],
        where: r_i.recipe_id == ^id
    )
  end

  @doc """
  Returns the list of recipe ingredients.

  ## Examples

      iex> list_recipe_ingredients()
      [%RecipeIngredient{}, ...]

  """
  def list_recipe_ingredients do
    Repo.all(RecipeIngredient)
  end

  @doc """
  Create recipe ingredient.
  """
  def create_recipe_ingredient(%Recipe{} = recipe, %Ingredient{} = ingredient, attrs) do
    attrs = Map.merge(attrs, %{"recipe_id" => recipe.id, "ingredient_id" => ingredient.id})

    %RecipeIngredient{}
    |> RecipeIngredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a change(set) recipe ingredient.

  ## Examples

      iex> change_recipe_ingredient(ingredient, %{amount: "123"})
      %Ecto.Changeset{data: %Ingredient{}}

  """
  def change_recipe_ingredient(%RecipeIngredient{} = recipe_ingredient, attrs) do
    RecipeIngredient.changeset(recipe_ingredient, attrs)
  end

  @doc """
  Updates a recipe ingredient.

  ## Examples

      iex> update_recipe_ingredient(recipe_ingredient, %{field: new_value})
      {:ok, %RecipeIngredient{}}

      iex> update_recipe_ingredient(recipe_ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_ingredient(%RecipeIngredient{} = recipe_ingredient, attrs) do
    recipe_ingredient
    |> RecipeIngredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe ingredient.
  """
  def delete_recipe_ingredient(%RecipeIngredient{} = recipe_ingredient) do
    Repo.delete(recipe_ingredient)
  end
end
