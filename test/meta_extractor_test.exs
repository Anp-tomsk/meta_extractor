defmodule MetaExtractorTest do
  use ExUnit.Case

  test "url fetcher fetch success :ok" do
    assert {:ok, _} = MetaExtractor.UrlFetcher.fetch("https://meduza.io")
  end

  test "parse meta tag count match" do
    content = "<div>
                <meta name=\"description\" content=\"Website for Elixir\" />
                <meta property=\"og:title\" content=\"Website for Elixir\" />
                <meta property=\"og:subtitle\" content=\"Website for Elixir\" />
               </div>"

    parse_result = MetaExtractor.Parser.parse(content)
    assert 3 == Enum.count(parse_result)
  end

  test "parse attribute with property and content" do
    meta = "<meta property=\"og:title\" content=\"Website for Elixir\" />"

    assert {"og:title", "Website for Elixir"} = MetaExtractor.Parser.parse_meta(meta)
  end

  test "parse attribute with name and content" do
    meta = "<meta name=\"description\" content=\"Website for Elixir\" />"

    assert {"description", "Website for Elixir"} = MetaExtractor.Parser.parse_meta(meta)
  end

  test "parse attribute no name and property :no_content" do
    meta = "<meta http-equiv-\"X-UA-Compatible\" content=\"IE=edge\" />"

    assert :no_content = MetaExtractor.Parser.parse_meta(meta)
  end
end
