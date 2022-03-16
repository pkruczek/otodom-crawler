defmodule Data.Offer.Size do
  defstruct rooms: 0, area: 0.0

  def new(rooms, area) do
    %Data.Offer.Size{rooms: rooms, area: area}
  end
end
