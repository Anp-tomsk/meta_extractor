defmodule MetaExtractor do
  alias MetaExtractor.{UrlFetcher, Parser}

  def from_url url do
    url
    |> UrlFetcher.fetch
    |> fn {:ok, body} -> Parser.parse(body) end.()
  end
  
end
