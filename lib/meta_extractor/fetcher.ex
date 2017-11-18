defmodule MetaExtractor.UrlFetcher do

  def fetch(url) do
    url
    |> HTTPoison.get!
    |> fn respons=%{headers: headers} ->
      handle_response(respons, is_gzip?(headers))
    end.()
  end

  defp is_gzip?(headers) do
    Enum.any?(headers, fn (kv) ->
      case kv do
        {"Content-Encoding", "gzip"} -> true
        {"Content-Encoding", "x-gzip"} -> true
        _ -> false
      end
    end)
  end

  def handle_response(%{status_code: 200, body: body}, _gzip = true) do
    {:ok, :zlib.gunzip(body)}
  end

  def handle_response(%{status_code: 200, body: body}, _gzip) do
    {:ok, body}
  end

  def handle_response(%{status_code: _}, _gzip) do
    :error
  end

end
