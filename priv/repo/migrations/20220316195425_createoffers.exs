defmodule Data.Offers.Repo.Migrations.Createoffers do
  use Ecto.Migration

  def change do
    create table(:offers) do
      add(:title, :string)
      add(:price, :integer)
      add(:address, :string)
      add(:size, :map)
      add(:link, :string)
    end
  end
end
