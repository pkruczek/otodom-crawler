defmodule OtodomSpider do
  use Crawly.Spider
  alias Crawly.Utils

  @impl Crawly.Spider
  def base_url(), do: "https://www.otodom.pl"

  @impl Crawly.Spider
  def init(), do: [start_urls: ["https://www.otodom.pl/pl/oferty/sprzedaz/mieszkanie/katowice"]]

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    hrefs = []

    requests =
      Utils.build_absolute_urls(hrefs, base_url())
      |> Utils.requests_from_urls()

    adverts =
      document
      |> Floki.find("a.css-jf4j3r")

    items =
      adverts
      |> Stream.map(&read_item/1)
      |> Stream.filter(&filter_errors/1)
      |> Enum.map(fn {_, result} -> result end)
      |> IO.inspect()

    %{
      :requests => requests,
      :items => items
    }
  end

  defp read_item(advert) do
    rescue_errors(fn ->
      %{
        title: Floki.find(advert, "h3.css-1fc77cf") |> Floki.text(),
        price: Floki.find(advert, "p.css-1bq5zfe") |> Floki.text() |> read_price(),
        address: Floki.find(advert, "span.css-17o293g") |> Floki.text(),
        size: Floki.find(advert, "p.css-6o5l1c") |> Floki.text() |> read_size(),
        link: Floki.find(advert, "a.css-jf4j3r") |> Floki.attribute("href") |> Enum.at(0)
      }
    end)
  end

  defp read_price(text) do
    text
    |> only_numbers()
    |> Integer.parse()
    |> elem(0)
  end

  defp read_size(text) do
    [rooms_txt, area_txt] =
      text
      |> String.split("pok")
      |> Enum.map(&only_numbers/1)

    {rooms, _} = Integer.parse(rooms_txt)
    {area, _} = Float.parse(area_txt)

    %{rooms: rooms, area: area}
  end

  defp only_numbers(text) do
    Regex.replace(~r/[^0-9.]/, text, "")
  end

  defp rescue_errors(operation) do
    try do
      {:ok, operation.()}
    rescue
      e -> {:error, e}
    end
  end

  defp filter_errors({:ok, _}), do: true
  defp filter_errors({:error, _}), do: false
end
