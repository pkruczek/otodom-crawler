defmodule Data.Saver do
  def insert_with_ecto(offer) do
    Data.Offers.Repo.insert(changeset(offer))
  end

  defp changeset(offer) do
    Data.Offer.changeset(%Data.Offer{}, offer)
  end
end
