defmodule LeodiDashboard.Shared.Type do
  @spec to_integer(String.t() | integer()) :: integer | String.t()
  def to_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {integer, _remainder} ->
        integer

      :error ->
        value
    end
  end

  def to_integer(value) when is_integer(value) do
    value
  end
end
