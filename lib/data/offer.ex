defmodule Data.Offer do
  use Ecto.Schema

  schema "offers" do
    field(:title, :string)
    field(:price, :integer)
    field(:address, :string)
    # TODO: Ecto.Type and jsonb
    field(:size, :string)
    field(:link, :string)
  end

  def changeset(offer, params \\ %{}) do
    offer
    |> Ecto.Changeset.cast(params, [:title, :price, :address, :size, :link])
    |> Ecto.Changeset.validate_required([:title, :price, :address, :size, :link])
  end
end
