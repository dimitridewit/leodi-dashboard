defmodule LeodiDashboardWeb.RecipeListView do
  use LeodiDashboardWeb, :view

  def is_active?(true), do: "is-active"
  def is_active?(_), do: ""
end
