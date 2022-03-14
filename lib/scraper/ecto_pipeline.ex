defmodule Scraper.EctoPipeline do
  @behaviour Crawly.Pipeline

  @impl true
  def run(item, state, _opts \\ []) do
    case Data.Saver.insert_with_ecto(item) do
      {:ok, _} ->
        {item, state}

      {:error, _} ->
        {false, state}
    end
  end
end
