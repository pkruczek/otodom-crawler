defmodule Data.Offer.EctoSize do
  use Ecto.Type
  alias Data.Offer.Size

  @impl true
  def type, do: :map

  @impl true
  def cast(%{rooms: rooms, area: area}) when is_integer(rooms) and is_number(area) do
    {:ok, Size.new(rooms, area)}
  end

  @impl true
  def cast(_), do: :error

  @impl true
  def load(map) when is_map(map) do
    data =
      for {key, value} <- map do
        {String.to_existing_atom(key), value}
      end

    {:ok, struct!(Size, data)}
  end

  @impl true
  def dump(%Size{} = size) do
    {:ok, Map.from_struct(size)}
  end

  @impl true
  def dump(_), do: :error
end
