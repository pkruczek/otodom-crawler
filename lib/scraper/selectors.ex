defmodule Scraper.Selectors do
    @default_selectors %{
        title: "h3.css-1fc77cf",
        price: "p.css-1bq5zfe",
        address: "span.css-17o293g",
        size: "p.css-6o5l1c",
        link: "a.css-jf4j3r"
    }

    def selector_of(selector) do
        selector_map()
        |> Map.fetch_env!(selector)
    end

    defp selector_map do
        env_map = Application.get_env(:scraper, :selectors, %{})
        Map.merge(@default_selectors, env_map)
    end
    
end