defmodule LeodiDashboardWeb.RecipeListLive.New do
  use LeodiDashboardWeb, :live_view
  alias LeodiDashboardWeb.Endpoint
  alias LeodiDashboard.List
  alias LeodiDashboard.List.RecipeList

  def render(assigns) do
    Phoenix.View.render(LeodiDashboardWeb.RecipeListView, "new.html", assigns)
  end

  def mount(params, session, socket) do
    recipe_list = List.change_recipe_list(%RecipeList{})

    {
      :ok,
      socket
      |> assign(:changeset, recipe_list)
    }
  end

  def handle_event("create", %{"recipe_list" => params}, socket) do
    case List.create_recipe_list(params) do
      {:ok, recipe_list = %RecipeList{}} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "RecipeList created successfully")
          |> redirect(to: Routes.recipe_list_edit_path(Endpoint, :edit, recipe_list))
        }

      {:error, changeset} ->
        {
          :noreply,
          socket
          |> assign(:changeset, changeset)
        }
    end
  end
end
