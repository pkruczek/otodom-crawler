defmodule Scraper.Selectors do
  @default_selectors %{
    offers: "a.css-1c4ocg7",
    title: "h3.css-1rhznz4",
    price: "p.css-1bq5zfe",
    address: "span.css-17o293g",
    size: "p.css-zng9ao",
    link: "a.css-1c4ocg7",
    page_not_found: "h3.css-1b2au34",
  }

  def selector_of(selector) do
    selector_map()
    |> Map.fetch!(selector)
  end

  defp selector_map do
    env_map = Application.get_env(:scraper, :selectors, %{})
    Map.merge(@default_selectors, env_map)
  end
end
