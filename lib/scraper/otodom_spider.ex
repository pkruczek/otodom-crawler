defmodule OtodomSpider do
  use Crawly.Spider
  import Scraper.Selectors

  @impl Crawly.Spider
  def base_url(), do: "https://www.otodom.pl"

  @impl Crawly.Spider
  def init(), do: [start_urls: [page_url(1)]]

  @impl Crawly.Spider
  def parse_item(response) do
    IO.puts("Scraping page #{response.request.url}")
    {:ok, document} = Floki.parse_document(response.body)

    adverts =
      document
      |> Floki.find(selector_of(:offers))

    items =
      adverts
      |> Stream.map(&read_item/1)
      |> Stream.filter(&filter_errors/1)
      |> Enum.map(fn {_, result} -> result end)
      |> IO.inspect()

    requests =
      next_requests(document, response.request.url)
      |> IO.inspect()
      |> Enum.map(&Crawly.Utils.request_from_url/1)

    %{
      :requests => requests,
      :items => items
    }
  end

  defp read_item(advert) do
    rescue_errors(fn ->
      %{
        title: Floki.find(advert, selector_of(:title)) |> Floki.text(),
        price: Floki.find(advert, selector_of(:price)) |> Floki.text() |> read_price(),
        address: Floki.find(advert, selector_of(:address)) |> Floki.text(),
        size: Floki.find(advert, selector_of(:size)) |> Floki.text() |> read_size(),
        link: Floki.find(advert, selector_of(:link)) |> Floki.attribute("href") |> Enum.at(0)
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

  defp next_requests(document, url) do
    unless page_exceeded?(document) do
      next_requests(url)
    else
      []
    end
  end

  defp page_exceeded?(document) do
    document
    |> Floki.find(selector_of(:page_not_found))
    |> Floki.text()
    |> String.contains?("Nie znaleziono")
  end

  defp next_requests(url) do
    case next_page(url) do
      {:ok, page} -> [page]
      {:error, _} -> []
    end
  end

  defp next_page(url) do
    rescue_errors(fn ->
      page_no = page(url)
      page_url(page_no + 1)
    end)
  end

  defp page(url) do
    Regex.run(~r/.*page=(\d+)/, url)
    |> Enum.at(1)
    |> Integer.parse()
    |> elem(0)
  end

  defp page_url(page_no) do
    ~s(https://www.otodom.pl/pl/oferty/sprzedaz/mieszkanie/katowice?page=#{page_no})
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
