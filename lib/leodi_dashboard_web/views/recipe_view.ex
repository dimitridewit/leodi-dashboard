defmodule LeodiDashboardWeb.RecipeView do
  use LeodiDashboardWeb, :view

  def is_active?(true), do: "is-active"
  def is_active?(_), do: ""

  def link_recipe_ingredients(ingredients, recipe_ingredients) do
    Enum.map(recipe_ingredients, fn r_i ->
      i = ingredients |> Enum.find(&(&1.id == r_i.ingredient_id))

      r_i
      |> Map.merge(Map.take(i, [:name]))
    end)
  end

  def multiselect_ingredients(form, field, options, opts \\ []) do
    {selected, _} = get_selected_values(form, field, opts)
    selected_as_strings = Enum.map(selected, &"#{&1}")

    for {value, key} <- options, into: [] do
      checkbox =
        content_tag(:label, class: "label") do
          [
            tag(:input,
              name: input_name(form, field) <> "[]",
              id: input_id(form, field, key),
              type: "checkbox",
              value: key,
              checked: Enum.member?(selected_as_strings, "#{key}")
            ),
            value
          ]
        end

      amount =
        content_tag(:label, class: "label") do
          [
            tag(:input,
              name: "recipe[ingredients][#{key}][amount]",
              id: "recipe_ingredients_amount"
            )
          ]
        end

      picked =
        tag(:input,
          name: "recipe[ingredients][#{key}][picked]",
          type: "checkbox",
          id: "recipe_ingredients_picked"
        )

      [value, picked, amount]
    end
  end

  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)
    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || input_value(form, field), opts}
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end
